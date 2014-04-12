{ stdenv, fetchurl, libcap }:

assert stdenv.isLinux -> libcap != null;

stdenv.mkDerivation rec {
  name = "ntp-4.2.6p5";

  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "077r69a41hasl8zf5c44km7cqgfhrkaj6a4jnr75j7nkz5qq7ayn";
  };

  configureFlags = ''
    --without-crypto
    ${if stdenv.isLinux then "--enable-linuxcaps" else ""}
  '';

  buildInputs = stdenv.lib.optional stdenv.isLinux libcap;
  # Do not useFakeTime here, as this can create indeterminism
  # in the version string, because ntp records how many times a
  # certain file is regenerated, and with libfaketime it can
  # happen more than once.
  patches = [ ./fixed-date-in-version-string.patch ];

  meta = {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
