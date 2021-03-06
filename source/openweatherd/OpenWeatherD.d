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

module openweatherd.openweatherd;

import openweatherd.options;
import openweatherd.units;
import openweatherd.languages;

class OpenWeatherD {

	/**
	 * Sets key value for the API.
	 *
	 * Params:
	 *		key =  A key value for the API.
	 */
	public void setKey(string key) {
		Options.getInstance().setKey(key);
	}

	/**
	 * Sets language value for the API.
	 *
	 * Params:
	 * 		language = A language value for the API.
	 */
	public void setLanguage(Languages language) {
		Options.getInstance().setLanguage(language);
	}

	/**
	 * Sets unit value for the API.
	 *
	 * Params:
	 * 		unit = A unit value for the API.
	 */
	public void setUnits(Units unit) {
		Options.getInstance().setUnits(unit);
	}
}
