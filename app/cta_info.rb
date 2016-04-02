Station = Struct.new(:id, :name)
class CTAInfo
  class << self ; attr_reader :stations ; end

  # last updated 04-02-2016
  @stations = {
    40830 => Station.new(40830, "18th"),
    41120 => Station.new(41120, "35th-Bronzeville-IIT"),
    40120 => Station.new(40120, "35th/Archer"),
    41270 => Station.new(41270, "43rd"),
    41080 => Station.new(41080, "47th (Green Line)"),
    41230 => Station.new(41230, "47th (Red Line)"),
    40130 => Station.new(40130, "51st"),
    40580 => Station.new(40580, "54th/Cermak"),
    40910 => Station.new(40910, "63rd"),
    40990 => Station.new(40990, "69th"),
    40240 => Station.new(40240, "79th"),
    41430 => Station.new(41430, "87th"),
    40450 => Station.new(40450, "95th/Dan Ryan"),
    40680 => Station.new(40680, "Adams/Wabash"),
    41240 => Station.new(41240, "Addison (Blue Line)"),
    41440 => Station.new(41440, "Addison (Brown Line)"),
    41420 => Station.new(41420, "Addison (Red Line)"),
    41200 => Station.new(41200, "Argyle"),
    40660 => Station.new(40660, "Armitage"),
    40170 => Station.new(40170, "Ashland (Green & Pink Lines)"),
    41060 => Station.new(41060, "Ashland (Orange Line)"),
    40290 => Station.new(40290, "Ashland/63rd"),
    40010 => Station.new(40010, "Austin (Blue Line)"),
    41260 => Station.new(41260, "Austin (Green Line)"),
    40060 => Station.new(40060, "Belmont (Blue Line)"),
    41320 => Station.new(41320, "Belmont (Red, Brown & Purple Lines)"),
    40340 => Station.new(40340, "Berwyn"),
    41380 => Station.new(41380, "Bryn Mawr"),
    40570 => Station.new(40570, "California (Blue Line)"),
    41360 => Station.new(41360, "California (Green Line)"),
    40440 => Station.new(40440, "California (Pink Line)"),
    40280 => Station.new(40280, "Central (Green Line)"),
    41250 => Station.new(41250, "Central (Purple Line)"),
    40780 => Station.new(40780, "Central Park"),
    41000 => Station.new(41000, "Cermak-Chinatown"),
    41690 => Station.new(41690, "Cermak-McCormick Place"),
    41410 => Station.new(41410, "Chicago (Blue Line)"),
    40710 => Station.new(40710, "Chicago (Brown & Purple Lines)"),
    41450 => Station.new(41450, "Chicago (Red Line)"),
    40970 => Station.new(40970, "Cicero (Blue Line)"),
    40480 => Station.new(40480, "Cicero (Green Line)"),
    40420 => Station.new(40420, "Cicero (Pink Line)"),
    40630 => Station.new(40630, "Clark/Division"),
    40380 => Station.new(40380, "Clark/Lake"),
    40430 => Station.new(40430, "Clinton (Blue Line)"),
    41160 => Station.new(41160, "Clinton (Green & Pink Lines)"),
    41670 => Station.new(41670, "Conservatory"),
    40720 => Station.new(40720, "Cottage Grove"),
    40230 => Station.new(40230, "Cumberland"),
    40590 => Station.new(40590, "Damen (Blue Line)"),
    40090 => Station.new(40090, "Damen (Brown Line)"),
    40210 => Station.new(40210, "Damen (Pink Line)"),
    40050 => Station.new(40050, "Davis"),
    40690 => Station.new(40690, "Dempster"),
    40140 => Station.new(40140, "Dempster-Skokie"),
    40530 => Station.new(40530, "Diversey"),
    40320 => Station.new(40320, "Division"),
    40390 => Station.new(40390, "Forest Park"),
    40520 => Station.new(40520, "Foster"),
    40870 => Station.new(40870, "Francisco"),
    41220 => Station.new(41220, "Fullerton"),
    40510 => Station.new(40510, "Garfield (Green Line)"),
    41170 => Station.new(41170, "Garfield (Red Line)"),
    40490 => Station.new(40490, "Grand (Blue Line)"),
    40330 => Station.new(40330, "Grand (Red Line)"),
    40760 => Station.new(40760, "Granville"),
    40940 => Station.new(40940, "Halsted (Green Line)"),
    41130 => Station.new(41130, "Halsted (Orange Line)"),
    40980 => Station.new(40980, "Harlem (Blue Line - Forest Park Branch)"),
    40750 => Station.new(40750, "Harlem (Blue Line - O'Hare Branch)"),
    40020 => Station.new(40020, "Harlem/Lake"),
    40850 => Station.new(40850, "Harold Washington Library-State/Van Buren"),
    41490 => Station.new(41490, "Harrison"),
    40900 => Station.new(40900, "Howard"),
    40810 => Station.new(40810, "Illinois Medical District"),
    40300 => Station.new(40300, "Indiana"),
    40550 => Station.new(40550, "Irving Park (Blue Line)"),
    41460 => Station.new(41460, "Irving Park (Brown Line)"),
    40070 => Station.new(40070, "Jackson (Blue Line)"),
    40560 => Station.new(40560, "Jackson (Red Line)"),
    41190 => Station.new(41190, "Jarvis"),
    41280 => Station.new(41280, "Jefferson Park"),
    41180 => Station.new(41180, "Kedzie (Brown Line)"),
    41070 => Station.new(41070, "Kedzie (Green Line)"),
    41150 => Station.new(41150, "Kedzie (Orange Line)"),
    41040 => Station.new(41040, "Kedzie (Pink Line)"),
    40250 => Station.new(40250, "Kedzie-Homan"),
    41290 => Station.new(41290, "Kimball"),
    41140 => Station.new(41140, "King Drive"),
    40600 => Station.new(40600, "Kostner"),
    41340 => Station.new(41340, "LaSalle"),
    40160 => Station.new(40160, "LaSalle/Van Buren"),
    41660 => Station.new(41660, "Lake"),
    40700 => Station.new(40700, "Laramie"),
    40770 => Station.new(40770, "Lawrence"),
    41050 => Station.new(41050, "Linden"),
    41020 => Station.new(41020, "Logan Square"),
    41300 => Station.new(41300, "Loyola"),
    40640 => Station.new(40640, "Madison/Wabash"),
    40270 => Station.new(40270, "Main"),
    40460 => Station.new(40460, "Merchandise Mart"),
    40930 => Station.new(40930, "Midway"),
    40790 => Station.new(40790, "Monroe (Blue Line)"),
    41090 => Station.new(41090, "Monroe (Red Line)"),
    41330 => Station.new(41330, "Montrose (Blue Line)"),
    41500 => Station.new(41500, "Montrose (Brown Line)"),
    41510 => Station.new(41510, "Morgan"),
    40100 => Station.new(40100, "Morse"),
    40650 => Station.new(40650, "North/Clybourn"),
    40400 => Station.new(40400, "Noyes"),
    40890 => Station.new(40890, "O'Hare"),
    40180 => Station.new(40180, "Oak Park (Blue Line)"),
    41350 => Station.new(41350, "Oak Park (Green Line)"),
    41680 => Station.new(41680, "Oakton-Skokie"),
    41310 => Station.new(41310, "Paulina"),
    41030 => Station.new(41030, "Polk"),
    40920 => Station.new(40920, "Pulaski (Blue Line)"),
    40030 => Station.new(40030, "Pulaski (Green Line)"),
    40960 => Station.new(40960, "Pulaski (Orange Line)"),
    40150 => Station.new(40150, "Pulaski (Pink Line)"),
    40040 => Station.new(40040, "Quincy/Wells"),
    40470 => Station.new(40470, "Racine"),
    40200 => Station.new(40200, "Randolph/Wabash"),
    40610 => Station.new(40610, "Ridgeland"),
    41010 => Station.new(41010, "Rockwell"),
    41400 => Station.new(41400, "Roosevelt"),
    40820 => Station.new(40820, "Rosemont"),
    40800 => Station.new(40800, "Sedgwick"),
    40080 => Station.new(40080, "Sheridan"),
    40840 => Station.new(40840, "South Boulevard"),
    40360 => Station.new(40360, "Southport"),
    40190 => Station.new(40190, "Sox-35th"),
    40260 => Station.new(40260, "State/Lake"),
    40880 => Station.new(40880, "Thorndale"),
    40350 => Station.new(40350, "UIC-Halsted"),
    40370 => Station.new(40370, "Washington"),
    40730 => Station.new(40730, "Washington/Wells"),
    41210 => Station.new(41210, "Wellington"),
    40220 => Station.new(40220, "Western (Blue Line - Forest Park Branch)"),
    40670 => Station.new(40670, "Western (Blue Line - O'Hare Branch)"),
    41480 => Station.new(41480, "Western (Brown Line)"),
    40310 => Station.new(40310, "Western (Orange Line)"),
    40740 => Station.new(40740, "Western (Pink Line)"),
    40540 => Station.new(40540, "Wilson")
  }
end
