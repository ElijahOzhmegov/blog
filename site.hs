--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import qualified Hakyll.Core.Metadata as Metadata


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match ("images/**" .||. "favicon.ico") $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/add-title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    tags <- buildTags ("posts/*" .||. "reviews/*") (fromCapture "tags/*")
    let postCtx = mconcat
          [ dateField "date" "%B %e, %Y"
          , teaserField "teaser" "content"
          , tagsField "tags" tags
          , postTitleCtx
          , defaultContext
          ]

    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged \"" ++ tag ++ "\""
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let ctx = constField "title" title
                    `mappend` listField "posts" postCtx (return posts)
                    `mappend` defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" ctx
                >>= loadAndApplyTemplate "templates/add-title.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html" postCtx
            >>= loadAndApplyTemplate "templates/add-title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "reviews/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/add-title.html" defaultContext
            >>= loadAndApplyTemplate "templates/default.html" postCtx

    match "reviews.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "reviews/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll ("posts/*" .||. "reviews/*.md")
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/add-title.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["sitemap.xml"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            singlePages <- loadAll (fromList ["about.rst", "contact.markdown"])
            reviews <- loadAll "reviews/*" -- here
            let pages = posts <> singlePages <> reviews
                sitemapCtx =
                    listField "pages" postCtx (return pages)
            makeItem ""
                >>= loadAndApplyTemplate "templates/sitemap.xml" sitemapCtx


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
postTitleCtx :: Context String
postTitleCtx = field "page_title" $ \item -> do
    metadata <- getMetadata (itemIdentifier item)
    return $ maybe "" (++ " | Ilia Ozhmegov's Personal Blog") $ Metadata.lookupString "title" metadata
    
--root :: String
--root = "https://iliaozhmegov.com"

postCtx :: Context String
postCtx =
    --constField "root" root      <> -- here
    dateField "date" "%Y-%m-%d" <>
    defaultContext
