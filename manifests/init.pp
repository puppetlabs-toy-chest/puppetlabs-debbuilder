class debbuilder(
  $pe = false,
  $use_cows = false,
  $cows = undef,
) {
  class { debbuilder::packages::essential: }

  if ($use_cows) {
    class { debbuilder::packages::extra: }
    if $cows {
      class { debbuilder::setup::cows: cows => $cows, }
    } else {
      class { debbuilder::setup::cows: }
    }
  }

  if ($pe) {
    class { debbuilder::setup::pe: }
  }
}
