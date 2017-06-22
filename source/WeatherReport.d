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

module openweatherd.weatherreport;

import openweatherd.weatherentry;

class WeatherReport {

    private WeatherEntry[] entries;

	/**
	 * Adds a new entry into the entries array of WeatherEntries.
	 *
	 * Params:
	 *		entry = A WeatherEntry to add to the WeatherReport.
	 */
    public void addEntry(WeatherEntry entry) {
        entries ~= entry;
    }

	/**
	 * Gets target entry from the entries array. This lets you work
	 * with the target entry with selected id.
	 *
	 * Params:
	 *		index = number that represents the index of target entry.
	 *
	 * Returns:
	 * 		a WeatherEntry from the entries array at index from parameters and
     * 		returns undefined if index is out of range.
	 */
    public WeatherEntry getEntry(int index) {
        return entries[index];
    }

	/**
	 * Returns an array of WeatherEntry used as a weather report.
	 *
	 * Returns:
	 * 		An array of WeatherEntries.
	 */
    public WeatherEntry[] getReport() {
        return entries;
    }
}