Station = Struct.new(:id, :name, :latitude, :longitude)
class CTAInfo
  class << self ; attr_reader :stations ; end

  # last updated 07-24-2016
  @stations = {
    40830 => Station.new(40830, "18th", 41.857908, -87.669147),
    41120 => Station.new(41120, "35th-Bronzeville-IIT", 41.831677, -87.625826),
    40120 => Station.new(40120, "35th/Archer", 41.829353, -87.680622),
    41270 => Station.new(41270, "43rd", 41.816462, -87.619021),
    41080 => Station.new(41080, "47th (Green Line)", 41.809209, -87.618826),
    41230 => Station.new(41230, "47th (Red Line)", 41.810318, -87.63094),
    40130 => Station.new(40130, "51st", 41.80209, -87.618487),
    40580 => Station.new(40580, "54th/Cermak", 41.85177331, -87.75669201),
    40910 => Station.new(40910, "63rd", 41.780536, -87.630952),
    40990 => Station.new(40990, "69th", 41.768367, -87.625724),
    40240 => Station.new(40240, "79th", 41.750419, -87.625112),
    41430 => Station.new(41430, "87th", 41.735372, -87.624717),
    40450 => Station.new(40450, "95th/Dan Ryan", 41.722377, -87.624342),
    40680 => Station.new(40680, "Adams/Wabash", 41.879507, -87.626037),
    41240 => Station.new(41240, "Addison (Blue Line)", 41.94738, -87.71906),
    41440 => Station.new(41440, "Addison (Brown Line)", 41.947028, -87.674642),
    41420 => Station.new(41420, "Addison (Red Line)", 41.947428, -87.653626),
    41200 => Station.new(41200, "Argyle", 41.973453, -87.65853),
    40660 => Station.new(40660, "Armitage", 41.918217, -87.652644),
    40170 => Station.new(40170, "Ashland (Green & Pink Lines)", 41.885269, -87.666969),
    41060 => Station.new(41060, "Ashland (Orange Line)", 41.839234, -87.665317),
    40290 => Station.new(40290, "Ashland/63rd", 41.77886, -87.663766),
    40010 => Station.new(40010, "Austin (Blue Line)", 41.870851, -87.776812),
    41260 => Station.new(41260, "Austin (Green Line)", 41.887293, -87.774135),
    40060 => Station.new(40060, "Belmont (Blue Line)", 41.938132, -87.712359),
    41320 => Station.new(41320, "Belmont (Red, Brown & Purple Lines)", 41.939751, -87.65338),
    40340 => Station.new(40340, "Berwyn", 41.977984, -87.658668),
    41380 => Station.new(41380, "Bryn Mawr", 41.983504, -87.65884),
    40570 => Station.new(40570, "California (Blue Line)", 41.921939, -87.69689),
    41360 => Station.new(41360, "California (Green Line)", 41.88422, -87.696234),
    40440 => Station.new(40440, "California (Pink Line)", 41.854109, -87.694774),
    40280 => Station.new(40280, "Central (Green Line)", 41.887389, -87.76565),
    41250 => Station.new(41250, "Central (Purple Line)", 42.063987, -87.685617),
    40780 => Station.new(40780, "Central Park", 41.853839, -87.714842),
    41000 => Station.new(41000, "Cermak-Chinatown", 41.853206, -87.630968),
    41690 => Station.new(41690, "Cermak-McCormick Place", 41.853115, -87.626402),
    41410 => Station.new(41410, "Chicago (Blue Line)", 41.896075, -87.655214),
    40710 => Station.new(40710, "Chicago (Brown & Purple Lines)", 41.89681, -87.635924),
    41450 => Station.new(41450, "Chicago (Red Line)", 41.896671, -87.628176),
    40970 => Station.new(40970, "Cicero (Blue Line)", 41.871574, -87.745154),
    40480 => Station.new(40480, "Cicero (Green Line)", 41.886519, -87.744698),
    40420 => Station.new(40420, "Cicero (Pink Line)", 41.85182, -87.745336),
    40630 => Station.new(40630, "Clark/Division", 41.90392, -87.631412),
    40380 => Station.new(40380, "Clark/Lake", 41.885737, -87.630886),
    40430 => Station.new(40430, "Clinton (Blue Line)", 41.875539, -87.640984),
    41160 => Station.new(41160, "Clinton (Green & Pink Lines)", 41.885678, -87.641782),
    41670 => Station.new(41670, "Conservatory", 41.884904, -87.716523),
    40720 => Station.new(40720, "Cottage Grove", 41.780309, -87.605857),
    40230 => Station.new(40230, "Cumberland", 41.984246, -87.838028),
    40590 => Station.new(40590, "Damen (Blue Line)", 41.909744, -87.677437),
    40090 => Station.new(40090, "Damen (Brown Line)", 41.966286, -87.678639),
    40210 => Station.new(40210, "Damen (Pink Line)", 41.854517, -87.675975),
    40050 => Station.new(40050, "Davis", 42.04771, -87.683543),
    40690 => Station.new(40690, "Dempster", 42.041655, -87.681602),
    40140 => Station.new(40140, "Dempster-Skokie", 42.038951, -87.751919),
    40530 => Station.new(40530, "Diversey", 41.932732, -87.653131),
    40320 => Station.new(40320, "Division", 41.903355, -87.666496),
    40390 => Station.new(40390, "Forest Park", 41.874257, -87.817318),
    40520 => Station.new(40520, "Foster", 42.05416, -87.68356),
    40870 => Station.new(40870, "Francisco", 41.966046, -87.701644),
    41220 => Station.new(41220, "Fullerton", 41.925051, -87.652866),
    40510 => Station.new(40510, "Garfield (Green Line)", 41.795172, -87.618327),
    41170 => Station.new(41170, "Garfield (Red Line)", 41.79542, -87.631157),
    40490 => Station.new(40490, "Grand (Blue Line)", 41.891189, -87.647578),
    40330 => Station.new(40330, "Grand (Red Line)", 41.891665, -87.628021),
    40760 => Station.new(40760, "Granville", 41.993664, -87.659202),
    40940 => Station.new(40940, "Halsted (Green Line)", 41.778943, -87.644244),
    41130 => Station.new(41130, "Halsted (Orange Line)", 41.84678, -87.648088),
    40980 => Station.new(40980, "Harlem (Blue Line - Forest Park Branch)", 41.87349, -87.806961),
    40750 => Station.new(40750, "Harlem (Blue Line - O'Hare Branch)", 41.98227, -87.8089),
    40020 => Station.new(40020, "Harlem/Lake", 41.886848, -87.803176),
    40850 => Station.new(40850, "Harold Washington Library-State/Van Buren", 41.876862, -87.628196),
    41490 => Station.new(41490, "Harrison", 41.874039, -87.627479),
    40900 => Station.new(40900, "Howard", 42.019063, -87.672892),
    40810 => Station.new(40810, "Illinois Medical District", 41.875706, -87.673932),
    40300 => Station.new(40300, "Indiana", 41.821732, -87.621371),
    40550 => Station.new(40550, "Irving Park (Blue Line)", 41.952925, -87.729229),
    41460 => Station.new(41460, "Irving Park (Brown Line)", 41.954521, -87.674868),
    40070 => Station.new(40070, "Jackson (Blue Line)", 41.878183, -87.629296),
    40560 => Station.new(40560, "Jackson (Red Line)", 41.878153, -87.627596),
    41190 => Station.new(41190, "Jarvis", 42.015876, -87.669092),
    41280 => Station.new(41280, "Jefferson Park", 41.970634, -87.760892),
    41180 => Station.new(41180, "Kedzie (Brown Line)", 41.965996, -87.708821),
    41070 => Station.new(41070, "Kedzie (Green Line)", 41.884321, -87.706155),
    41150 => Station.new(41150, "Kedzie (Orange Line)", 41.804236, -87.704406),
    41040 => Station.new(41040, "Kedzie (Pink Line)", 41.853964, -87.705408),
    40250 => Station.new(40250, "Kedzie-Homan", 41.874341, -87.70604),
    41290 => Station.new(41290, "Kimball", 41.967901, -87.713065),
    41140 => Station.new(41140, "King Drive", 41.78013, -87.615546),
    40600 => Station.new(40600, "Kostner", 41.853751, -87.733258),
    41340 => Station.new(41340, "LaSalle", 41.875568, -87.631722),
    40160 => Station.new(40160, "LaSalle/Van Buren", 41.8768, -87.631739),
    41660 => Station.new(41660, "Lake", 41.884809, -87.627813),
    40700 => Station.new(40700, "Laramie", 41.887163, -87.754986),
    40770 => Station.new(40770, "Lawrence", 41.969139, -87.658493),
    41050 => Station.new(41050, "Linden", 42.073153, -87.69073),
    41020 => Station.new(41020, "Logan Square", 41.929728, -87.708541),
    41300 => Station.new(41300, "Loyola", 42.001073, -87.661061),
    40640 => Station.new(40640, "Madison/Wabash", 41.882023, -87.626098),
    40270 => Station.new(40270, "Main", 42.033456, -87.679538),
    40460 => Station.new(40460, "Merchandise Mart", 41.888969, -87.633924),
    40930 => Station.new(40930, "Midway", 41.78661, -87.737875),
    40790 => Station.new(40790, "Monroe (Blue Line)", 41.880703, -87.629378),
    41090 => Station.new(41090, "Monroe (Red Line)", 41.880745, -87.627696),
    41330 => Station.new(41330, "Montrose (Blue Line)", 41.961539, -87.743574),
    41500 => Station.new(41500, "Montrose (Brown Line)", 41.961756, -87.675047),
    41510 => Station.new(41510, "Morgan", 41.885586, -87.652193),
    40100 => Station.new(40100, "Morse", 42.008362, -87.665909),
    40650 => Station.new(40650, "North/Clybourn", 41.910655, -87.649177),
    40400 => Station.new(40400, "Noyes", 42.058282, -87.683337),
    40890 => Station.new(40890, "O'Hare", 41.97766526, -87.90422307),
    40180 => Station.new(40180, "Oak Park (Blue Line)", 41.872108, -87.791602),
    41350 => Station.new(41350, "Oak Park (Green Line)", 41.886988, -87.793783),
    41680 => Station.new(41680, "Oakton-Skokie", 42.02624348, -87.74722084),
    41310 => Station.new(41310, "Paulina", 41.943623, -87.670907),
    41030 => Station.new(41030, "Polk", 41.871551, -87.66953),
    40920 => Station.new(40920, "Pulaski (Blue Line)", 41.873797, -87.725663),
    40030 => Station.new(40030, "Pulaski (Green Line)", 41.885412, -87.725404),
    40960 => Station.new(40960, "Pulaski (Orange Line)", 41.799756, -87.724493),
    40150 => Station.new(40150, "Pulaski (Pink Line)", 41.853732, -87.724311),
    40040 => Station.new(40040, "Quincy/Wells", 41.878723, -87.63374),
    40470 => Station.new(40470, "Racine", 41.87592, -87.659458),
    40200 => Station.new(40200, "Randolph/Wabash", 41.884431, -87.626149),
    40610 => Station.new(40610, "Ridgeland", 41.887159, -87.783661),
    41010 => Station.new(41010, "Rockwell", 41.966115, -87.6941),
    41400 => Station.new(41400, "Roosevelt", 41.867405, -87.62659),
    40820 => Station.new(40820, "Rosemont", 41.983507, -87.859388),
    40800 => Station.new(40800, "Sedgwick", 41.910409, -87.639302),
    40080 => Station.new(40080, "Sheridan", 41.953775, -87.654929),
    40840 => Station.new(40840, "South Boulevard", 42.027612, -87.678329),
    40360 => Station.new(40360, "Southport", 41.943744, -87.663619),
    40190 => Station.new(40190, "Sox-35th", 41.831191, -87.630636),
    40260 => Station.new(40260, "State/Lake", 41.88574, -87.627835),
    40880 => Station.new(40880, "Thorndale", 41.990259, -87.659076),
    40350 => Station.new(40350, "UIC-Halsted", 41.875474, -87.649707),
    40370 => Station.new(40370, "Washington", 41.883164, -87.62944),
    40730 => Station.new(40730, "Washington/Wells", 41.882695, -87.63378),
    41210 => Station.new(41210, "Wellington", 41.936033, -87.653266),
    40220 => Station.new(40220, "Western (Blue Line - Forest Park Branch)", 41.875478, -87.688436),
    40670 => Station.new(40670, "Western (Blue Line - O'Hare Branch)", 41.916157, -87.687364),
    41480 => Station.new(41480, "Western (Brown Line)", 41.966163, -87.688502),
    40310 => Station.new(40310, "Western (Orange Line)", 41.804546, -87.684019),
    40740 => Station.new(40740, "Western (Pink Line)", 41.854225, -87.685129),
    40540 => Station.new(40540, "Wilson", 41.964273, -87.657588)
  }
end
