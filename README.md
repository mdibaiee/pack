Pack
====

Dead-simple self-hosted cloud storage. I made this for learning purposes, you probably shouldn't use it in production.

How it works
-----------

Clone the repository on your server and run it

```
bundle install
rails s
```

Then install the client:

```
gem install packc
```

This will add a `pack` executable to your `PATH`, now you can upload/watch for files using the client. Try:

```
pack
```
