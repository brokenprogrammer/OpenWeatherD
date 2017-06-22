import std.stdio;
import openweatherd.options;
import openweatherd.units;
import openweatherd.weatherentry;
import openweatherd.currentweather;
import openweatherd.location;

void main () {
    Options options = Options.getInstance();

    // Set the api key the library should use.
    options.setKey("1d334b0f0f23fccba1cee7d3f4934ea7");

    // Set which temperature units the library should use (Default is Kelvin).
    options.setUnits(Units.DEFAULT);

    // Get location by id.
    // Full id list can be viewed at: http://openweathermap.org/current
    Location location = Location.getById(6_198_442);
    
    // Get location by name and city.
    location = Location.getByName("London", "UK");

    // Get current weather for target location.
    WeatherEntry entry = CurrentWeather.getWeather(location);

    writeln("Current weather description: ", entry.description);
    writeln("Current weather icon id: ", entry.icon);

    writeln("Current weather temperature: ", entry.temperature);
    writeln("Current weather pressure: ", entry.pressure);
    writeln("Current weather humidity: ", entry.humidity);

    writeln("Current weather minimum temperature: ", entry.minimum);
    writeln("Current weather minimum temperature: ", entry.maximum);

    writeln("Current weather sea level pressure: ", entry.seaLevel);
    writeln("Current weather ground level pressure: ", entry.grndLevel);

    writeln("Current weather wind speed: ", entry.windSpeed);
    writeln("Current weather wind direction: ", entry.windDirection);

    writeln("Current weather cloudiness: ", entry.cloudiness);
    writeln("Current weather rain volume: ", entry.rainVolume);
    writeln("Current weather snow volume: ", entry.snowVolume);

    writeln("Location id: ", entry.location.id);
    writeln("Location name: ", entry.location.name);
    writeln("Location latitude: ", entry.location.latitude);
    writeln("Location longitude: ", entry.location.longitude);
    writeln("Location country: ", entry.location.country);

    writeln(entry.time);
}