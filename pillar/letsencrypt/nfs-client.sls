nfs:
  mount:
    somename:
      mountpoint: "/var/www/letsencrypt"
      location: "salt.donthack.me:/var/www/letsencrypt"
      persist: True
      mkmnt: True
      opts: "rw"
