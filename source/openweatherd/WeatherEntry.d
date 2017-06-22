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

module openweatherd.weatherentry;

import openweatherd.weathercondition;
import openweatherd.location;

struct WeatherEntry {
    WeatherCondition condition; /** weather condition id */
    string main;                /** group of weather parameters */
    string description;         /** weather condition within the group */
    string icon;                /** weather icon id */

    float temperature;          /** temperature */
    int pressure;               /** atmospheric pressure, hPa */
    int humidity;               /** humidity, % */
    float minimum;              /** minimum temperature at the moment */
    float maximum;              /** maximum temperature at the moment */
    int seaLevel;               /** atmospheric pressure on the sea level, hPa */
    int grndLevel;              /** atmospheric pressure on the ground level, hPa */

    int windSpeed;              /** wind speed */
    int windDirection;          /** wind direction */

    int cloudiness;             /** cloudiness, % */
    int rainVolume;             /** rain volume for the last 3 hours */
    int snowVolume;             /** snow volume for the last 3 hours */

    Location location;          /** city id, name, country code and coordinates */
    int time;                   /** time of data calculation, unix, UTC */
    int sunrise;                /** sunrise time */
    int sunset;                 /** sunset time */
}