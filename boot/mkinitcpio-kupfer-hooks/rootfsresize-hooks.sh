#!/usr/bin/ash

run_hook() {
  # rootfsdetect must be run first, or otherwise a root variable must be defined in the boot cmdline
  if [ -n $root ]; then
    echo "root variable undefined. Aborting..."
    return 1
  fi

  # Check if root is inside of a nested partition table and fall over to resizing fs if not
  if [ "$root" == "/dev/loop*" ]; then
    _subpartnumber="$(echo $root | grep -Eo '[0-9]+$')"
    _loopdev="${root%%p$_subpartnumber}"
    if parted -s "$_loopdev" print free | tail -n2 | head -n1 | grep -qi "free space"; then
      echo "Found unallocated space on a subpartition. Resizing..."
      parted -s "$_loopdev" resizepart "$_subpartnumber" 100%
      partprobe
    fi
  fi

  e2fsck -fy "$root"
  # There is no need to check if filesystem needs to be resized since resize2fs already checks unless "-f" is specified
  resize2fs "$root"
}
