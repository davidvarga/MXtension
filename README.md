# MXtension
MXtension (Matlab Extensions) is a library to provide in other languages well known constructions (containers with mutability, higher order functions from functional programming, etc) in Matlab.

Warning
-------

Until the first stable release this repository is only a work in progress!

Containers
----------

Provides well known containers (list, set and map in the first version), mutable and immutable versions of them, extension functionalities on them and as well higher-order functions known from functional programming such as:

 - filter
 - map
 - reduce
 - fold
 - ...
 
The container interfaces are based on the corresponding Java built-in classes, the extension functionalities and the higher-order functions is strongly based on Kotlin.

What's planned in the first version?
------------------------------------

In the first version `List`, `MutableList` (untyped), `Map` - `MutableMap` (typed for keys) and `Set` - `MutableSet` (untyped) are planned together with the extension functions.


