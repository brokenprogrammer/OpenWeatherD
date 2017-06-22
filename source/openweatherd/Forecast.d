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

module openweatherd.forecast;

import std.conv;
import openweatherd.languages;
import openweatherd.location;
import openweatherd.locationtype;
import openweatherd.options;
import openweatherd.weatherentry;
import openweatherd.weatherreport;
import openweatherd.weathercondition;
import openweatherd.units;
import std.uni;
import std.string;
import std.net.curl;
import std.json;

class Forecast {

    /**
	 * Returns a 5 day 3 hourly weather forecast for a given location value.
	 *
	 * Params:
	 *		location =  A location value.
     * Return: 
     *      A current WeatherReport for a given location.
	 */
    public static WeatherReport getHourlyForecast(Location location) {
        Options options = Options.getInstance();
		string url;
        WeatherReport report = new WeatherReport();

        switch (location.type) {
		case LocationType.ID:
			url = "http://api.openweathermap.org/data/2.5/forecast?id=" ~ to!string(location.id)
                ~ "&mode=json";
			break;
		case LocationType.NAME:
			url = "http://api.openweathermap.org/data/2.5/forecast?q=" ~ location.name
				~ "&mode=json";
			break;
		case LocationType.COORDINATES:
			url = "http://api.openweathermap.org/data/2.5/forecast?lat=" ~ to!string(location.latitude)
				~ "&lon=" ~ to!string(location.longitude);
			break;
		
		default: break;
		}

        // Set API language value
		url = url ~ "&lang=" ~ toLower(to!string(options.getLanguage()));

		// Set API units value
		url = url ~ "&units=" ~ toLower(to!string(options.getUnits()));

		// Set API key value
		url = url ~ "&appid=" ~ options.getKey();

        auto content = get(url);
		JSONValue response = parseJSON(content);

        for (int i; i < to!int(response.object["cnt"].integer); i++) {
            WeatherEntry entry;

            entry.condition = to!WeatherCondition(to!int(response.object["list"].array[i].object["weather"].array[0].object["id"].integer));
            entry.main = response.object["list"].array[i].object["weather"].array[0].object["main"].str;
            entry.description = response.object["list"].array[i].object["weather"].array[0].object["description"].str;
            entry.icon = response.object["list"].array[i].object["weather"].array[0].object["icon"].str;

           if (const(JSONValue)* temp = "temp" in response.object["list"].array[i].object["main"]) {
                if (temp.type() == JSON_TYPE.INTEGER) {
                    entry.temperature = to!int(response.object["list"].array[i].object["main"].object["temp"].integer);
                } else if (temp.type() == JSON_TYPE.FLOAT) {
                    entry.temperature = response.object["list"].array[i].object["main"].object["temp"].floating;
                }
            }

            if (const(JSONValue)* tempmin = "temp_min" in response.object["list"].array[i].object["main"]) {
                if (tempmin.type() == JSON_TYPE.INTEGER) {
                    entry.minimum = to!int(response.object["list"].array[i].object["main"].object["temp_min"].integer);
                } else if (tempmin.type() == JSON_TYPE.FLOAT) {
                    entry.minimum = response.object["list"].array[i].object["main"].object["temp_min"].floating;
                }
            }

            if (const(JSONValue)* tempmax = "temp_max" in response.object["list"].array[i].object["main"]) {
                if (tempmax.type() == JSON_TYPE.INTEGER) {
                    entry.maximum = to!int(response.object["list"].array[i].object["main"].object["temp_max"].integer);
                } else if (tempmax.type() == JSON_TYPE.FLOAT) {
                    entry.maximum = response.object["list"].array[i].object["main"].object["temp_max"].floating;
                }
            }

            if (const(JSONValue)* pressure = "pressure" in response.object["list"].array[i].object["main"]) {
                if (pressure.type() == JSON_TYPE.INTEGER) {
                    entry.pressure = to!int(response.object["list"].array[i].object["main"].object["pressure"].integer);
                } else if (pressure.type() == JSON_TYPE.FLOAT) {
                    entry.pressure = to!int(response.object["list"].array[i].object["main"].object["pressure"].floating);
                }
            }

            if (const(JSONValue)* humidity = "humidity" in response.object["list"].array[i].object["main"]) {
                if (humidity.type() == JSON_TYPE.INTEGER) {
                    entry.humidity = to!int(response.object["list"].array[i].object["main"].object["humidity"].integer);
                } else if (humidity.type() == JSON_TYPE.FLOAT) {
                    entry.humidity = to!int(response.object["list"].array[i].object["main"].object["humidity"].floating);
                }
            }

            if (const(JSONValue)* sea_level = "sea_level" in response) {
                entry.seaLevel = to!int(response.object["list"].array[i].object["main"].object["sea_level"].integer);
            } else {
                entry.seaLevel = to!int(entry.pressure);
            }

            if (const(JSONValue)* grnd_level = "grnd_level" in response) {
                entry.grndLevel = to!int(response.object["list"].array[i].object["main"].object["grnd_level"].integer);
            } else {
                entry.grndLevel = to!int(entry.pressure);
            }

            if (const(JSONValue)* windspeed = "speed" in response.object["list"].array[i].object["wind"]) {
                if (windspeed.type() == JSON_TYPE.INTEGER) {
                    entry.windSpeed = to!int(response.object["list"].array[i].object["wind"].object["speed"].integer);
                } else if (windspeed.type() == JSON_TYPE.FLOAT) {
                    entry.windSpeed = to!int(response.object["list"].array[i].object["wind"].object["speed"].floating);
                }
            } else {
                entry.windSpeed = 0;
            }

            if (const(JSONValue)* winddirection = "deg" in response.object["list"].array[i].object["wind"]) {
                if (winddirection.type() == JSON_TYPE.INTEGER) {
                    entry.windDirection = to!int(response.object["list"].array[i].object["wind"].object["deg"].integer);
                } else if (winddirection.type() == JSON_TYPE.FLOAT) {
                    entry.windDirection = to!int(response.object["list"].array[i].object["wind"].object["deg"].floating);
                }
            } else {
                entry.windDirection = 0;
            }

            entry.cloudiness = to!int(response.object["list"].array[i].object["clouds"].object["all"].integer);

            if (const(JSONValue)* rain = "rain" in response.object["list"].array[i]) {
                if (const(JSONValue)* threeh = "3h" in response.object["list"].array[i]) {
                    entry.rainVolume = to!int(response.object["list"].array[i].object["rain"].object["3h"].integer);
                }
            } else {
                entry.rainVolume = 0;
            }

            if (const(JSONValue)* rain = "snow" in response.object["list"].array[i]) {
                if (const(JSONValue)* threeh = "3h" in response.object["list"].array[i]) {
                    entry.snowVolume = to!int(response.object["list"].array[i].object["snow"].object["3h"].integer);
                }
            } else {
                entry.snowVolume = 0;
            }

            location.id = to!int(response.object["city"].object["id"].integer);
            location.name = response.object["city"].object["name"].str;
            location.latitude = response.object["city"].object["coord"].object["lat"].floating;
            location.longitude = response.object["city"].object["coord"].object["lon"].floating;
            location.country = response.object["city"].object["country"].str;

            entry.location = location;

            report.addEntry(entry);
        }

        return report;
    }

    unittest {
        Options options = Options.getInstance();
		options.setKey("1d334b0f0f23fccba1cee7d3f4934ea7");
		options.setUnits(Units.DEFAULT);

        Location location = Location.getByName("London", "UK");
        WeatherReport entry = getHourlyForecast(location); 

        assert(entry.getReport()[0].location.id == 2_643_743);
        assert(entry.getReport()[0].location.name == "London");
		assert(entry.getReport()[0].location.latitude == 51.5085);
		assert(entry.getReport()[0].location.longitude == -0.1258);
		assert(entry.getReport()[0].location.country == "GB");

        assert(entry.getReport()[0].pressure >= 980 && entry.getReport()[0].pressure <= 1050);
        assert(entry.getReport()[0].humidity >= 0 && entry.getReport()[0].humidity <= 100);
        assert(entry.getReport()[0].seaLevel >= 980 && entry.getReport()[0].seaLevel <= 1050);
        assert(entry.getReport()[0].grndLevel >= 980 && entry.getReport()[0].grndLevel <= 1050);

        assert(entry.getReport()[0].windSpeed >= 0 && entry.getReport()[0].windSpeed <= 16);
        assert(entry.getReport()[0].windDirection >= 0 && entry.getReport()[0].windDirection <= 360);

        assert(entry.getReport()[0].cloudiness >= 0 && entry.getReport()[0].cloudiness <= 100);
        assert(entry.getReport()[0].rainVolume >= 0 && entry.getReport()[0].rainVolume <= 10);
        assert(entry.getReport()[0].snowVolume >= 0 && entry.getReport()[0].snowVolume <= 10);

        /* Metrics */
        options.setUnits(Units.METRIC);
        entry = getHourlyForecast(location);

        assert(entry.getReport()[0].temperature >= -43 && entry.getReport()[0].temperature <= 46);
        assert(entry.getReport()[0].minimum >= -43 && entry.getReport()[0].minimum <= 46);
        assert(entry.getReport()[0].maximum >= -43 && entry.getReport()[0].maximum <= 46);
        assert(entry.getReport()[0].windSpeed >= 0 && entry.getReport()[0].windSpeed <= 16);

        /* Imperial */
        options.setUnits(Units.IMPERIAL);
        entry = getHourlyForecast(location);

        assert(entry.getReport()[0].temperature >= -45 && entry.getReport()[0].temperature <= 116);
        assert(entry.getReport()[0].minimum >= -45 && entry.getReport()[0].minimum <= 116);
        assert(entry.getReport()[0].maximum >= -45 && entry.getReport()[0].maximum <= 116);
        assert(entry.getReport()[0].windSpeed >= 0 && entry.getReport()[0].windSpeed <= 35);
    }
}