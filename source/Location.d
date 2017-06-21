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

module openweatherd.location;

import openweatherd.locationtype;

struct Location {
    LocationType type;

    int id;
    string name;
    double latitude = 0;
    double longitude = 0;
    string zip;
    string country;

    static Location getById(int id) {
        Location location;

        location.type = LocationType.ID;
        location.id = id;

        return location;
    }

    static Location getByName(string name, string country) {
        Location location;

        location.type = LocationType.NAME;
        location.name = name;
        location.country = country;

        return location;
    }

    static Location getByCoordinates(double latitude, double longitude) {
        Location location;

        location.type = LocationType.COORDINATES;
        location.latitude = latitude;
        location.longitude = longitude;

        return location;
    }

    static Location getByZip(string zip, string country) {
        Location location;

        location.type = LocationType.ZIP;
        location.zip = zip;
        location.country = country;

        return location;
    }

    bool equals(Location location) {
        return location.type == this.type
            && location.id == this.id
            && location.name == this.name
            && location.latitude == this.latitude
            && location.longitude == this.longitude
            && location.zip == this.zip
            && location.country == this.country;
    }

    unittest {
        assert(Location.getById(6_198_442).id == 6_198_442);

        assert(Location.getByName("Cheboksary", "RU").name == "Cheboksary");
        assert(Location.getByName("Cheboksary", "RU").country == "RU");

        assert(Location.getByCoordinates(56.174999, 47.286388).latitude == 56.174999);
        assert(Location.getByCoordinates(56.174999, 47.286388).longitude == 47.286388);

        assert(Location.getByZip("428000", "RU").zip == "428000");
        assert(Location.getByZip("428000", "RU").country == "RU");

        Location location = Location.getById(6_198_442);
        assert(Location.getById(6_198_442).equals(location) == true);
        assert(Location.getByName("Cheboksary", "RU").equals(location) == false);
    }
}