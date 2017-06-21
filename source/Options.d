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

    public string getKey() {
        return (key !is null)
            ? this.key
            : "";
    }

    public Languages getLanguage() {
        return this.language;
    }

    public Units getUnits() {
        return this.unit;
    }

    public int getTimeout() {
        return (this.timeout != 0)
            ? this.timeout
            : this.TIMEOUT_DEFAULT;
    }

    public int getAttempts() {
        return (this.attempts != 0)
            ? this.attempts
            : this.ATTEMPTS_DEFAULT; 
    }

    public void setKey(string key) {
        this.key = key;
    }

    public void setLanguage(Languages language) {
        this.language = language;
    }

    public void setUnits(Units unit) {
        this.unit = unit;
    }

    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }

    public void setAttempts(int attempts) {
        this.attempts = attempts;
    }
}