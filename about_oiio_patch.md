In order to correctly build OIIO with Conan a number of changes need to be made to OIIO's CMake scripts.
This file documents these changes.

* `CMakeLists.txt`:

  * `conan_basic_setup()` needs to be added at the beginning of the file.

* `src/cmake/externalpackages.cmake`:

  * `add_definitions (-DOPENEXR_DLL)` needs to be removed. `OpenEXR::OpenEXR` target is used instead.

  * `set (Boost_USE_STATIC_LIBS ON)` needs to be removed. This flag is set by linking against `Boost::Boost` target.

  * `add_definitions (-DBOOST_ALL_DYN_LINK=1)` needs to be removed. The same reason as above.

  * `include_directories` and `link_libraries` for Boost libs need to be replaced by `find_package(Boost REQUIRED)` and `link_libraries(Boost::Boost)`.

  * The conditional which calls `list (APPEND Boost_LIBRARIES "rt")` needs to be removed. The same reason as above.

  * Call to `include_directories` for OpenEXR should be replaced with `include_directories(${OpenEXR_INCLUDE_DIRS})`.
    OIIO's FindOpenEXR module uses `OPENEXR_` prefix for its variables, while conan-generated Find module uses `OpenEXR_` prefix.

  * `set(OPENEXR_LIBRARIES ${OpenEXR_LIBRARIES})` needs to be added. The same reason as above.

  * `checked_find_package (Qt5 COMPONENTS ${qt5_modules})` can be removed. This speeds up build.

  * Instead of find package `PNG`, find `libpng` (using conan-generated Find module)

* `src/jpeg2000.imageio/CMakeLists.txt`:

  * Variable prefixes `OPENJPEG_` need to be replaced with `OpenJPEG_`. OIIO's Find module uses `OPENEXR_` prefix while conan-generated module uses `OpenEXR_`.

* `src/cmake/oiio_macros.cmake`:

  * `oiio_add_tests` macro should be renamed to `_DISABLED_oiio_add_tests` and a no-op `oiio_add_tests` macro should be added. This speeds up build.

* `src/cmake/compiler.cmake`:

  * Add `string(REPLACE " /W3 " " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")` after adding `add_compile_options (/W1)`. This reduces number of warnings when building.

* `src/nuke/txWriter/CMakeLists.txt` and `src/nuke/txReader/CMakeLists.txt`:

  * Remove `/W3` flags for MSVC. The same reason as above.
