/++
	MIT License

	Copyright (c) 2017 Oskar Mendel

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
+/

module openweatherd.currentweather;

import std.stdio;
import std.conv;
import openweatherd.languages;
import openweatherd.location;
import openweatherd.locationtype;
import openweatherd.options;
import openweatherd.weatherentry;
import openweatherd.weathercondition;
import openweatherd.units;
import std.uni;
import std.string;
import std.net.curl;
import std.json;

class CurrentWeather {

    public static WeatherEntry getWeather(Location location) {
        Options options = Options.getInstance();
		string url;

		switch (location.type) {
		case LocationType.ID:
			url = "http://api.openweathermap.org/data/2.5/weather?id=" ~ to!string(location.id);
			break;
		case LocationType.NAME:
			url = "http://api.openweathermap.org/data/2.5/weather?q=" ~ location.name
				~ "," ~ location.country;
			break;
		case LocationType.COORDINATES:
			url = "http://api.openweathermap.org/data/2.5/weather?lat=" ~ to!string(location.latitude)
				~ "&lon=" ~ to!string(location.longitude);
			break;
		case LocationType.ZIP:
			url = "http://api.openweathermap.org/data/2.5/weather?zip=" ~ location.zip
				~ "," ~ location.country;
			break;
		
		default: break;
		}

		// Set API language value
		url = url ~ "&lang=" ~ toLower(to!string(options.getLanguage()));

		// Set API units value
		url = url ~ "&units=" ~ toLower(to!string(options.getUnits()));

		// Set API key value
		url = url ~ "&appid=" ~ options.getKey();

		// Parse stuff
		auto content = get(url);
		JSONValue response = parseJSON(content);

		WeatherEntry entry;
		entry.condition = to!WeatherCondition(to!int(response.object["weather"].array[0].object["id"].integer));
		entry.main = response.object["weather"].array[0].object["main"].str;
		entry.description = response.object["weather"].array[0].object["description"].str;
		entry.icon = response.object["weather"].array[0].object["icon"].str;

		// If the units are metric it is retrieved as an integer.
		if (options.getUnits() == Units.METRIC) {
			entry.temperature = to!int(response.object["main"].object["temp"].integer);
			entry.minimum = to!int(response.object["main"].object["temp_min"].integer);
			entry.maximum = to!int(response.object["main"].object["temp_max"].integer);
		} else {
			entry.temperature = response.object["main"].object["temp"].floating;
			entry.minimum = response.object["main"].object["temp_min"].floating;
			entry.maximum = response.object["main"].object["temp_max"].floating;
		}
		
		entry.pressure = to!int(response.object["main"].object["pressure"].integer);
		entry.humidity = to!int(response.object["main"].object["humidity"].integer);

		if (const(JSONValue)* sea_level = "sea_level" in response) {
			entry.seaLevel = to!int(response.object["main"].object["sea_level"].integer);
		} else {
			entry.seaLevel = to!int(response.object["main"].object["pressure"].integer);
		}

		if (const(JSONValue)* grnd_level = "grnd_level" in response) {
			entry.grndLevel = to!int(response.object["main"].object["grnd_level"].integer);
		} else {
			entry.grndLevel = to!int(response.object["main"].object["pressure"].integer);
		}

		if (const(JSONValue)* wind = "wind" in response) {
			if (options.getUnits() == Units.IMPERIAL) {
				entry.windSpeed = to!int(response.object["wind"].object["speed"].floating);
			} else {
				entry.windSpeed = to!int(response.object["wind"].object["speed"].integer);
			}
			entry.windDirection = to!int(response.object["wind"].object["deg"].integer);
		} else {
			entry.windSpeed = 0;
			entry.windDirection = 0;
		}

		entry.cloudiness = to!int(response.object["clouds"].object["all"].integer);

		if (const(JSONValue)* rain = "rain" in response) {
			if (const(JSONValue)* threeh = "3h" in response) {
				entry.rainVolume = to!int(response.object["rain"].object["3h"].integer);
			}
		} else {
			entry.rainVolume = 0;
		}

		if (const(JSONValue)* rain = "snow" in response) {
			if (const(JSONValue)* threeh = "3h" in response) {
				entry.snowVolume = to!int(response.object["snow"].object["3h"].integer);
			}
		} else {
			entry.snowVolume = 0;
		}

		location.id = to!int(response.object["id"].integer);
		location.name = response.object["name"].str;
		location.latitude = response.object["coord"].object["lat"].floating;
		location.longitude = response.object["coord"].object["lon"].floating;
		location.country = response.object["sys"].object["country"].str;

		entry.location = location;
		entry.time = to!int(response.object["dt"].integer);
		entry.sunrise = to!int(response.object["sys"].object["sunrise"].integer);
		entry.sunset = to!int(response.object["sys"].object["sunset"].integer);

		return entry;
    }

	unittest {
		Options options = Options.getInstance();
		options.setKey("1d334b0f0f23fccba1cee7d3f4934ea7");
		options.setUnits(Units.DEFAULT);

		WeatherEntry entry = getWeather(Location.getById(6_198_442)); 

		assert(entry.temperature >= 230 && entry.temperature <= 320);
		assert(entry.pressure >= 980 && entry.pressure <= 1050);
		assert(entry.humidity >= 0 && entry.humidity <= 100);
		assert(entry.minimum >= 230 && entry.minimum <= 320);
		assert(entry.maximum >= 230 && entry.maximum <= 320);
		assert(entry.seaLevel >= 980 && entry.seaLevel <= 1050);
		assert(entry.grndLevel >= 980 && entry.grndLevel <= 1050);

		assert(entry.windSpeed >= 0 && entry.windSpeed <= 16);
		assert(entry.windDirection >= 0 && entry.windDirection <= 360);

		assert(entry.cloudiness >= 0 && entry.cloudiness <= 100);
		assert(entry.rainVolume >= 0 && entry.rainVolume <= 10);
		assert(entry.snowVolume >= 0 && entry.snowVolume <= 10);

		assert(entry.location.id == 6_198_442);
		assert(entry.location.name == "Cheboksary");
		assert(entry.location.latitude == 56.17);
		assert(entry.location.longitude == 47.29);
		assert(entry.location.country == "RU");

		/* Metrics */
		options.setUnits(Units.METRIC);
		entry = getWeather(Location.getById(6_198_442));

		assert(entry.temperature >= -43 && entry.temperature <= 46);
		assert(entry.minimum >= -43 && entry.minimum <= 46);
		assert(entry.maximum >= -43 && entry.maximum <= 46);
		assert(entry.windSpeed >= 0 && entry.windSpeed <= 16);

		/* Imperial */
		options.setUnits(Units.IMPERIAL);
		entry = getWeather(Location.getById(6_198_442));

		assert(entry.temperature >= -45 && entry.temperature <= 116);
		assert(entry.minimum >= -45 && entry.minimum <= 116);
		assert(entry.maximum >= -45 && entry.maximum <= 116);
		assert(entry.windSpeed >= 0 && entry.windSpeed <= 35);
	}
}