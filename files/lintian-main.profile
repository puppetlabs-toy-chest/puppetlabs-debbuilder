# Haus says "This file is managed by puppet; don't edit it or we'll put it back"
Profile: puppetlabs/main
Extends: debian/main
Enable-Tags-From-Check: binaries, changelog-file, changes-file, conffiles,
 control-file, control-files, copyright-file, cruft, deb-format, debconf,
 debhelper, debian-readme, debian-source-dir, description, duplicate-files,
 fields, filename-length, files, huge-usr-share, infofiles, init.d, java,
 lintian, manpages, md5sums, menu-format, menus, nmu, ocaml, patch-systems,
 po-debconf, rules, scripts, shared-libs, source-copyright, standards-version,
 symlinks, version-substvars, watch-file
Disable-Tags: bad-distribution-in-changes-file,multiple-distributions-in-changes-file,dir-or-file-in-opt,
 binary-or-shlib-defines-rpath
