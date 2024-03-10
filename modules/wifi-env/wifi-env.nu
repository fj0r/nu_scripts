export def 'wifi ssid' [dev=wlan0] {
    if (which iw | is-empty) {
        print -e 'please install iw'
    } else {
        iw dev $dev link | awk '/SSID/{print $2}'
    }
}

export def regex_match [val, tbl] {
    for i in ($tbl | transpose k v | where k != '_') {
        if ($val | find -ir $i.k | is-not-empty) {
            return (do $i.v $val)
        }
    }
    if ('_' in $tbl) {
        return (do ($tbl | get '_') $val)
    }
}


export def regex_match_record [val, tbl] {
    mut ev = {}
    for i in ($tbl | transpose k v | where k != '_') {
        if ($val | find -ir $i.k | is-not-empty) {
            $ev = $i.v
            break
        }
    }
    if ($ev | is-empty) and ('_' in $tbl) {
        $ev = ($tbl | get '_')
    }
    $ev
}


export def 'wifi select' [dev tbl] {
    let ssid = wifi ssid $dev
    regex_match $ssid $tbl
}

export def --env 'wifi env' [dev tbl] {
    let ssid = wifi ssid $dev
    regex_match_record $ssid $tbl | load-env
}
