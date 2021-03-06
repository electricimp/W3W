# What Three Words 1.0.0

[What Three Words](https://what3words.com/) (W3W) is a navigation service which aims to make geographical locations more manageable — for humans, at least. The World has been segmented into a grid of 3m x 3m squares, each one represented by a unique combination of three words. For example, the Statue of Liberty is located within the square referenced by the words `chief.ramp.songs`.

Multiple languages are supported for the geo-reference words.

**This library is in development and not yet available through `#require`. Please paste the library code into your application**

![Build Status](https://cse-ci.electricimp.com/app/rest/builds/buildType:(id:W3w_Build_And_Test)/statusIcon)

## Library Usage

THe W3W library is implemented as a Squirrel table. As such, it has no constructor, but you will need to call its *init()* function in order to set both your W3W API key and the callback through which the library communicates with your application. You must call *init()* before calling any other W3W function.

### The Callback

W3W uses a single callback for all notifications to the host application, whether returning data or reporting errors. You can use a single handler function for both, as shown in the example below. The handler will always receive a table.

When location data is returned via the callback, it contains the same information, whether you requested words from a set of co-ordinates, or vice versa. In either case, the returned table contains the following keys:

| Key | Value&nbsp;Type | Description |
| --- | --- | --- |
| *words* | String | The three words for the specified location |
| *coords* | Table | The co-ordinates of the specified location. Contains the keys *latitude* and *longitude* |
| *rawdata* | Table | All the data returned by W3W — see the [W3W API documentation]() |

An error report will contain the following keys:

| Key | Value&nbsp;Type | Description |
| --- | --- | --- |
| *error* | String | The W3W error message |
| *code* | Integer | The W3W error message |
| *statuscode* | Integer | The HTTP response status code |

#### Example

```squirrel
// Set the API key
const W3W_API_KEY = "<YOUR_W3W_API_KEY>";

// Define the notification handler
function cb(result) {
    if ("error" in result) {
        server.error(result.error + ", code: " + result.errcode);
    } else {
        server.log(result.words);
    }
}

// Make library settings choices
local settings = {
    "callback": cb,
    "apiKey": W3W_API_KEY
};

// Initialize and use library
W3W.init(settings);
W3W.getCoords(savedWords);
```

## Library Functions

### init(*settings*)

Configure the library. You must call this before making use of the library’s other functions, including values for *apiKey* and *callback*.

#### Parameters

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *apiKey* | String | Yes | Your W3W API key |
| *callback* | Function | Yes | The library’s notification callback. See [**The Callback**](#the-callback) for details |
| *language* | String | No | Your preferred language. Supply an [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)  two-letter code. Default: `en` |

#### Returns

Nothing.

### getWords(*coordinates[, getGeoJson]*)

Find the three-word representation of the supplied latitude and longitude co-ordinates in [WGS84](https://en.wikipedia.org/wiki/World_Geodetic_System) format. The co-ordinates can be passed in a string, an array of strings, or an array of floats. Take care with the latter: because of the rounding implicit in Squirrel’s conversion of floats to strings (required for transmission to W3W) you may lose precision and so may not receive the three words you expect.

Optionally, request the results are returned in [GeoJson](https://geojson.org) format rather than W3W’s JSON format.

Returned data or errors are posted via the callback. Returned data is in the form of a table with the following keys:

| Key | Type | Description |
| --- | --- | --- |
| *words* | String | The three words as single, period-separated string |
| *coords* | Table | The original co-ordinates via keys *lat* and *lng* |
| *rawdata* | Table | All the data sent by W3W |

#### Parameters

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *coordinates* | String or array of strings, floats or integers | Yes | Latitude and Longitude co-ordinates |

#### Returns

Nothing.

#### Examples

```squirrel
W3W.getWords("51.551208,-0.1348044");
W3W.getWords(["51.551208", "-0.1348044"]);
W3W.getWords([51.551208, -0.1348044]);
```

### getCoords(*words[, getGeoJson]*)

Get the latitude and longitude co-ordinates of the supplied three words. Optionally, request the results are returned in [GeoJson](https://geojson.org) format rather than W3W’s JSON format.

Returned data or errors are posted via the callback. Returned data is in the form of a table with the keys listed above under [*getWords()*](#getwordscoordinates-getgeojson)

#### Parameters

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *words* | String or array of strings | Yes | The supplied three words, eg. `no.address.here` |

#### Returns

Nothing.

#### Examples

```squirrel
W3W.getCoords("chief.ramp.songs");
W3W.getCoords(["chief", "ramp", "songs"]);
```

## Release Notes

* 1.0.0
    * Release candidate.
* 0.0.3
    * Match internal error reporting to W3W spec.
    * Correct precision on float->string conversion.
    * Correctly request responses in GeoJSON format.
    * Correctly parse GeoJSON responses.
    * Add `.impt.test`.
* 0.0.2
    * Improve code, error checks.
* 0.0.1
    * Initial release.