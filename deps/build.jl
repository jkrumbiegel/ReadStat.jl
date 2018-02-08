using BinaryProvider

# This is where all binaries will get installed
const prefix = Prefix(!isempty(ARGS) ? ARGS[1] : joinpath(@__DIR__,"usr"))

products = [
ExecutableProduct(prefix, "readstat"),
LibraryProduct(prefix, String["libreadstat"])
]

libreadstat = products[2]


# Download binaries from hosted location
bin_prefix = "https://github.com/davidanthoff/ReadStatBuilder/releases/download/v0.1.1-build.2"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    BinaryProvider.Linux(:aarch64, :glibc) => ("$bin_prefix/libreadstat.aarch64-linux-gnu.tar.gz", "36a7f26adbebb5a57f14d5bb259117951e54da956f0843f71adbd41efc41db20"),
    BinaryProvider.Linux(:armv7l, :glibc) => ("$bin_prefix/libreadstat.arm-linux-gnueabihf.tar.gz", "732e4451318d33af76c3044b2ae1cc3b47f60666acdd4d87516674b80cef06be"),
    BinaryProvider.Linux(:i686, :glibc) => ("$bin_prefix/libreadstat.i686-linux-gnu.tar.gz", "d3bf266cde0158cc87c667cf2615a7e75e481bd283383ae7ea854b469cef643c"),
    BinaryProvider.Windows(:i686) => ("$bin_prefix/libreadstat.i686-w64-mingw32.tar.gz", "e2c1f9978dc7e45baae0b6f993db17568d64275c323b8c81eb6305793272c2e8"),
    BinaryProvider.Linux(:powerpc64le, :glibc) => ("$bin_prefix/libreadstat.powerpc64le-linux-gnu.tar.gz", "eed504edb5875cb2d42dd0da6b3303b6160051d19ca5400908e7c2bd2c095de3"),
    BinaryProvider.MacOS() => ("$bin_prefix/libreadstat.x86_64-apple-darwin14.tar.gz", "e97ae99db5e4f65b405aa8807d4e5f665ad3fecd8ccb6f5dd7b49755c3807789"),
    BinaryProvider.Linux(:x86_64, :glibc) => ("$bin_prefix/libreadstat.x86_64-linux-gnu.tar.gz", "638d14f9d96a14c3f3cd7c4f457f65f4d4a885b9d81f66685b8d769d670a2102"),
    BinaryProvider.Windows(:x86_64) => ("$bin_prefix/libreadstat.x86_64-w64-mingw32.tar.gz", "2ba0862b45cf8e358e575eb8569fb1704d76c56dd1fcd5b39cf37a4896a52aed"),
)
if platform_key() in keys(download_info)
    # First, check to see if we're all satisfied
    if any(!satisfied(p; verbose=true) for p in products)
        # Download and install binaries
        url, tarball_hash = download_info[platform_key()]
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    end

    # Finally, write out a deps.jl file that will contain mappings for each
    # named product here: (there will be a "libfoo" variable and a "fooifier"
    # variable, etc...)
    @write_deps_file libreadstat
else
    error("Your platform $(Sys.MACHINE) is not supported by this package!")
end
