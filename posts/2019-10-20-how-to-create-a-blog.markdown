---
title: How to create a blog?
tags: Hakyll, Haskell, html, css, markdown
---

I guess this article is useful for those who has some experience in computer science and/or familiar with (ba)sh commands in general, To be honest if you use OSX or Linux like Ubuntu it would be a really easy journey. Otherwise, I think to install Ubuntu as the second OS is good idea.

 Well, in this article I will explain how to create your own blog on hakyll library. Also, I will cover some problems, that I faced during my first attempts to build the first site.

<!--more-->

First of all, you need to rent a virtual hosting and domain name for you site. As it's the easiest part of our journey, so this stage wouldn't be covered in this article. Let's focus on technical part.

## 1. Installing <b>stack</b> program

	$ curl -sSL https://get.haskellstack.org/ | sh
or

	$ wget -qO- https://get.haskellstack.org/ | sh

or alternatively on OSX you can do it via **brew** packet manager:

	$ brew install haskell-stack

## 2. Installing hakyll library
But before we getting started I should draw your attention to the version of desired snapshot (bunch of haskell packages) as not all of them have hakyll library. On the moment of writing this article the latest is **lts-12.26**. You can check it out by yourself:

2.1. Click on [snapshots](https://www.stackage.org/package/hakyll/snapshots); 

2.2. Move down and find `LTS Haskell xy.ab`; 

2.3. Remember `xy.ab` in my case `xy.ab` is `12.26`;

2.4. Install hakyll:

	$ stack install hakyll --resolver lts-12.26

## 3. Building the example site

	$ stack exec hakyll-init my-site

The command above creates a folder named `my-site` in the current directory with some example content and configuration files.

Sometimes `hakyll-init` is not found, so you should make sure your stack bin path (usually `$HOME/.local/bin`) is in your `$PATH`. You can check your stack local bin path by running `stack path --local-bin` or `echo $PATH`.

## 4. Compiling your site

The file `site.hs` contains the configuration of your site, as an executable haskell program. We need compile and run it in the following way:

	$ cd my-site
	$ stack init  # creates stack.yaml
	$ stack build
	$ stack exec site build

## 5. Launching a local server for preview

	$ stack exec site watch

You can edit files during "watching" process and the process will automatically rebuild it, so you just need to refresh your page to see the difference.

Let's look at your site at [http://localhost:8000/](http://localhost:8000/)!
