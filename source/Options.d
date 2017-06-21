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

module openweatherd.options;

import openweatherd.languages;
import openweatherd.units;

class Options {
    private static Options instance;

    public const int TIMEOUT_DEFAULT = 4096;
    public const int ATTEMPTS_DEFAULT = 3;

    private string key;
    private Languages language;
    private Units unit;
    private int timeout;
    private int attempts;

    private this() {}

    public static Options getInstance() {
        if (Options.instance is null) {
            Options.instance = new Options();
        }

        return Options.instance;
    }

    /**
	 * Returns the set API key or an empty string if its not set.
	 *
	 * Return: An API key value.
	 */
    public string getKey() {
        return (key !is null)
            ? this.key
            : "";
    }

    /**
	 * Returns the set API language value or an english if its not set.
	 *
	 * Return: An API language value.
	 */
    public Languages getLanguage() {
        return this.language;
    }

    /**
	 * Returns the set API units or Kelvin if its not set.
	 *
	 * Return: An API units value.
	 */
    public Units getUnits() {
        return this.unit;
    }

    /**
	 * Returns the set timeout or 4096 if its not set.
	 *
	 * Return: An API timeout value.
	 */
    public int getTimeout() {
        return (this.timeout != 0)
            ? this.timeout
            : this.TIMEOUT_DEFAULT;
    }

    /**
	 * Returns the set API attempts or 3 if its not set.
	 *
	 * Return: An API attempts value.
	 */
    public int getAttempts() {
        return (this.attempts != 0)
            ? this.attempts
            : this.ATTEMPTS_DEFAULT; 
    }

    /**
	 * Sets the API key value.
	 * 
	 * Params:
	 *		key =  An API key value.
	 */
    public void setKey(string key) {
        this.key = key;
    }

    /**
	 * Sets the API language value.
	 * 
	 * Params:
	 *		language =  An API language value.
	 */
    public void setLanguage(Languages language) {
        this.language = language;
    }

    /**
	 * Sets the API unit value.
	 * 
	 * Params:
	 *		unit =  An API unit value.
	 */
    public void setUnits(Units unit) {
        this.unit = unit;
    }

    /**
	 * Sets the API timeout value.
	 * 
	 * Params:
	 *		timeout =  An API timeout value.
	 */
    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }

    /**
	 * Sets the API attempts value.
	 * 
	 * Params:
	 *		attempts =  An API attempts value.
	 */
    public void setAttempts(int attempts) {
        this.attempts = attempts;
    }
}