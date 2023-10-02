# How to Contribute

## Overview
This project is written almost entirely in [Elm](https://elm-lang.org/) aka elmlang, a strongly typed, functional language optimized for web development.

Specifically, we're using a platform called [Lamdera](https://dashboard.lamdera.app/docs/overview) which lets us write both our FrontEnd _and_ our BackEnd code in Elm.

## Steps to get working

1. Create a local clone of this repo on your machine.
2. [Download Lamdera](https://dashboard.lamdera.app/docs/download). You'll be using Lamdera instead of the native Elm binary. This link provides the appropriate terminal commands for your platform. For example, if on a Mac, you would use
```
curl https://static.lamdera.com/bin/lamdera-1.2.0-macos-x86_64 -o /usr/local/bin/lamdera
chmod a+x /usr/local/bin/lamdera
```
3. If you're using Visual Studio Code, install the Elmlang extension. **Note**: There are two language extensions in the VSCode ecosystem but older (seemingly more popular one) has been deprecated. The deprecated version may show up first in Search, so be sure to check the descriptions.
4. Go to the settings of your elm extension and in the field
5. Install elm-format and elm-test. In your terminal or some other shell environment, type `npm install -g elm-format elm-test`
6. Add this point, you should be able to run `elm-live` and get a local server up and running with the project.







