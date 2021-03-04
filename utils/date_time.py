#!/usr/bin/env python3

import datetime
from os import name
from astral import LocationInfo
from astral.sun import sun
import read_config as rc

def get_suntime():
    location = rc.get_location()
    city = LocationInfo(name=location['city'],
                        region=location['country'],
                        timezone=location['timezone'],
                        latitude=location['latitude'],
                        longitude=location['longitude'])
    city_sun = sun(city.observer, date=datetime.date.today(), tzinfo=city.timezone)

    city_sunrise = city_sun['sunrise'].time()
    city_sunset = city_sun['sunset'].time()

    print(city_sunrise.minute, city_sunrise.hour,
          city_sunset.minute, city_sunset.hour)

if __name__ == '__main__':
    get_suntime()
