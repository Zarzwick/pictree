=======
Pictree
=======

*This is a WIP project. Don't expect clean code :>*

Pictree is a tool and library that takes a format string as well as image
files and produce an internal representation of an image tree whose layout is
automatic. This representation can then be converted into whatever you like ;
the only currently implemented output format is TiKZ.

The command ``pictree --fmt '1 2 (mat 3 3 3-11) 12' image*.png`` would produce
four horizontal blocks of the same size, with the third one being filled by a
3×3 matrix. Numbers are the identifiers of the files, assuming there are 12
images in the current folder.

The motivation initially comes from the unpleasant exercise of having to
assemble by hand many pictures in LaTeX documents, being it publications,
reports, or whatever.

-----
Build
-----

You will need ``ghc``, ``happy`` and ``alex``, as well as the
``optparse-applicative`` package. ::

    cabal build

.. ------------------
.. Crop/scale dilemna
.. ------------------

.. At some point one has to decide whether to crop or downscale an image, in
.. order to make it fit with its neighbours. Many choices are possible but also
.. totally arbitrary. On the other hand here is the function describing the area
.. of an image w.r.t the downscale and crop alterations.

.. .. maths ::

    .. area_{scale}(s) = s^2*w*h

.. .. maths ::

    .. area_{crop.}(c) = (1-2c)*w*h

.. Based on this the user can chose between crop-first, scale-first, crop-only,
.. scale-only, and in which proportions. The default is crop-first at a max of
.. :math:`2*5\text{%}` of the image height or width and then rescale.
.. 
.. Yet in the end, the choice will also be based on supposed aesthetics (e.g.
.. similar width/height, etc...) and should be controllable since no good
.. default exists.

