/*
 * What Three Words (W3W) library
 * Copyright 2021 Twilio
 *
 * MIT License
 * SPDX-License-Identifier: MIT
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
 * EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/*
 * Enums
 */
enum W3W_LIB {
    API_URL           = "https://api.what3words.com",
    API_VSN           = "v3",
    API_GET_WORDS_EP  = "convert-to-3wa",
    API_GET_COORDS_EP = "convert-to-coordinates"
}

// NOTE The following errors and codes are not comprehensive.
//      They list the errors the library passes back, not all
//      of those thart W3W may return
enum W3W_ERRS {
    BAD_COORDS        = "[W3W] Invalid co-ordinates",
    BAD_WORDS         = "[W3W] Invalid words",
    BAD_KEY           = "[W3W] Invalid API key"
}

enum W3W_ERR_CODES {
    BAD_COORDS        = "BadCoordinates",
    BAD_WORDS         = "BadWords",
    BAD_KEY           = "MissingKey",
}

/*
 * Library
 */
W3W <- {

    /* API details: https://developer.what3words.com/public-api/docs#overview */

    VERSION = "0.0.3",

    /* PRIVATE PROPERTIES */
    _apiKey = null,
    _cb = null,
    _debug = false,
    _lang = null,

    /* PUBLIC FUNCTIONS */

    /**
     * The W3W initializer.
     *
     * @constructor
     *
     * @param {string}   apiKey   - What Three Words developer API key.
     * @param {function} callback - Library response and notification handler provided by app.
     *
    */
    init = function(opts = null) {

        _cb     = ("callback" in opts && typeof opts.callback == "function") ? opts.callback : null;
        _debug  = ("debug" in opts && typeof opts.debug == "bool") ? opts.debug : false;
        _apiKey = ("apiKey" in opts && typeof opts.apiKey == "string" && opts.apiKey.len() > 0) ? opts.apiKey : null;
        _lang   = ("language" in opts && typeof opts.language == "string") ? opts.language : "en";

        if (_cb == null) throw "W3W requires a callback";
        if (_apiKey == null) _cb({ "error": W3W_ERRS.BAD_KEY,
                                   "errcode": W3W_ERR_CODES.BAD_KEY,
                                   "statuscode": 401 });
    },

    /**
     * Get the three words that reference the supplied latitude and longitude co-ordinates.
     *
     * @param {string/array} coords  - The desired co-ordinates. Pass as a string, eg. '-x.xxx,-y.yyy'
     *                                 or an array, eg. '[-x.xxx,-y.yyy]'
     * @param {bool}         geoJson - Should the request return GeoJson. Default: false.
     *
    */
    getWords = function(coords = null, getGeoJson = false) {

        if (coords == null ||
            (typeof coords == "string" && coords.len() == 0) ||
            (typeof coords == "array"  && coords.len() < 2)) {
                _cb({ "error": W3W_ERRS.BAD_COORDS,
                      "errcode": W3W_ERR_CODES.BAD_COORDS,
                      "statuscode": 400 });
                return;
        }

        // NOTE Co-ordinates expected as LAT,LNG
        local params = "?coordinates=";
        local paramsError = true;

        if (typeof coords == "string") {
            params += coords;
            paramsError = _checkLat(coords);
        } else if (typeof coords == "array") {
            // Use a 'try' in case string conversion fails
            try {
                for (local i = 0 ; i < 2 ; i++) {
                    // Use 'format()' for floats rather than '.tostring()' for better precision
                    params += (typeof coords[i] == "string") ? coords[i] : format("%.6f", coords[i]);
                    if (i == 0) params += ",";
                }
                paramsError = _checkLat(coords);
            } catch (err) { }
        }

        // Bail on error from above
        if (paramsError) {
            _cb({ "error": W3W_ERRS.BAD_COORDS,
                  "errcode": W3W_ERR_CODES.BAD_COORDS,
                   "statuscode": 400 });
            return;
        }

        // Select response JSON type
        if (typeof getGeoJson == "boolean" && getGeoJson) params += "&format=geojson";

        // Assemble and make the request
        _send(params);
    },

    /**
     * Get the coordinates indicated by the supplied three words.
     *
     * @param {string/array} coords  - The three words. Pass as a string, eg. "fellow.green.oak"
     *                                 or an array, eg. '["fellow", "green", "oak"]'
     * @param {bool}         geoJson - Should the request return GeoJson. Default: false.
     *
    */
    getCoords = function(words = null, getGeoJson = false) {
        if (words == null ||
            (typeof words == "string" && words.len() == 0) ||
            (typeof words == "array"  && words.len() != 3)) {
                _cb({ "error": W3W_ERRS.BAD_WORDS,
                      "errcode": W3W_ERR_CODES.BAD_WORDS,
                      "statuscode": 400 });
                return;
        }

        local params = "?words=";
        local paramsError = true;

        if (typeof words == "array") {
            // Check the words in the array are strings too
            foreach(item in words) {
                if (typeof item != "string") {
                    _cb({ "error": W3W_ERRS.BAD_WORDS,
                          "errcode": W3W_ERR_CODES.BAD_WORDS,
                          "statuscode": 400 });
                    return;
                }
            }
            params += (words[0] + "." + words[1] + "." + words[2]);
            paramsError = false;
        } else if (typeof words == "string") {
            if (split(words, ".").len() == 3) {
                params += words;
                paramsError = false;
            } else if (split(words, "・").len() == 3) {
                // Deal with coding of Japanese middle dot by removing it
                local parts = split(words, "・");
                params += (parts[0] + "." + parts[1] + "." + parts[2]);
                paramsError = false;
            }
        }

        if (paramsError) {
            _cb({ "error": W3W_ERRS.BAD_WORDS,
                  "errcode": W3W_ERR_CODES.BAD_WORDS,
                  "statuscode": 400 });
            return;
        }

        // Select response JSON type
        if (typeof getGeoJson == "boolean" && getGeoJson) params += "&format=geojson";

        // Assemble and make the request
        _send(params, false);
    },

    /* PRIVATE FUNCTIONS -- DO NOT CALL */

    /**
     * Internal HTTP request constructor.
     *
     * @private
     *
     * @param {string} params    - The request parameters (URL encoded).
     * param {bool}    wantWords - Whether it's a get words request. Default: true.
     *
    */
    _send = function(params, wantWords = true) {
        // Assemble and make the request
        local url = W3W_LIB.API_URL + "/" + W3W_LIB.API_VSN + "/";
        url += (wantWords ? W3W_LIB.API_GET_WORDS_EP : W3W_LIB.API_GET_COORDS_EP);
        local urlencoded = url + params + "&language=" + _lang + "&key=" + _apiKey
        if (_debug) server.log(urlencoded);
        http.get(urlencoded).sendasync(_handler.bindenv(this));
    },

    /**
     * Internal HTTP response handler.
     *
     * @private
     *
     * @param {HTTPresponse} resp - The imp API response object.
     *
    */
    _handler = function(resp) {

        if (resp.statuscode != 200) {
            _processError(resp);
            return;
        }

        // Return the JSON response for procesing by host
        local decode = http.jsondecode(resp.body);
        local data = { "words": decode.words,
                       "coords": { "latitude": decode.coordinates.lat,
                                   "longitude": decode.coordinates.lng },
                       "rawdata": decode };
        _cb(data);
    },

    /**
     * Internal error processor.
     *
     * @private
     *
     * @param {HTTPresponse} resp - The imp API response object.
     *
    */
    _processError = function(resp) {

        if (_debug) server.log("[W3W] " + resp.body + "(status code: " + resp.statuscode + ")");
        local err = http.jsondecode(resp.body);
        local errData = {"statuscode": resp.statuscode};

        if ("error" in err) {
            errData.error <- err.error.message;
            errData.errcode <- err.error.code;
        };

        _cb(errData);
    },

    /**
     * Internal latitide coordinate checker.
     *
     * @private
     *
     * @param {array/string} coords - The app-supplied coordinates.
     *
    */
    _checkLat = function(coords) {
        if (typeof coords == "array") {
            if (coords[0].tofloat() <= 90.0 && coords[0].tofloat() >= -90.0) {
                return false;
            }
        } else if (typeof coords == "string") {
            local parts = split(coords, ",");
            try {
                if (parts[0].tofloat() <= 90.0 && parts[1].tofloat() >= -90.0) {
                    return false;
                }
            } catch (err) { }
        }

        return true;
    }

}