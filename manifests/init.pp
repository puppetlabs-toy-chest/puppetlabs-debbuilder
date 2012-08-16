class debbuilder(
  $pe = false,
  $use_cows = false,
  $cows = undef,
  $cow_root = undef,
) {
  class { debbuilder::packages::essential: }

  if ($use_cows) {
    class { debbuilder::packages::extra: }
    class { debbuilder::setup::cows: cows => $cows, cow_root => $cow_root, pe => $pe }
  }
}
