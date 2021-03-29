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

enum W3W_ERRS {
    BAD_COORDS        = "[W3W] Invalid co-ordinates",
    BAD_WORDS         = "[W3W] Invalid words",
    BAD_KEY           = "[W3W] Invalid API key"
}

/*
 * Library
 */
W3W <- {

    /* API details: https://developer.what3words.com/public-api/docs#overview */

    VERSION = "0.0.1",

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
        if (_apiKey == null) _cb({ "error": W3W_ERRS.BAD_KEY, "errcode": 401 });
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

        if (coords == null) {
            _cb({ "error": W3W_ERRS.BAD_COORDS, "errcode": 400 });
            return;
        }

        // NOTE Co-ordinates expected as LNG,LAT
        local params = "?coordinates=";
        if (typeof coords == "string") {
            if (coords.len() > 0) {
                params += coords;
            } else {
                _cb({ "error": W3W_ERRS.BAD_COORDS, "errcode": 400 });
                return;
            }

        }

        if (typeof coords == "array") {
            if (coords.len() >= 2) {
                params += (coords[1].tostring() + "," + coords[0].tostring());
            } else {
                _cb({ "error": W3W_ERRS.BAD_COORDS, "errcode": 400 });
                return;
            }
        }

        // Select response JSON type
        if (typeof getGeoJson == "boolean" && getGeoJson) params += "&format=geojson";

        // Assemble and make the request
        _send(params);
    },

    getCoords = function(words = null) {
        if (words == null ||
            (typeof words == "string" && words.len() == 0) ||
            (typeof words == "array" && words.len() != 3)) {
                _cb({ "error": W3W_ERRS.BAD_WORDS, "errcode": 400 });
                return;
        }

        local params = "?";
        if (typeof words == "array") {
            // Check the words in the array are strings too
            foreach(item in words) {
                if (typeof item != "string") {
                    _cb({ "error": W3W_ERRS.BAD_WORDS, "errcode": 400 });
                    return;
                }
            }
            params += (words[0] + "." + words[1] + "." + words[2]);
        } else {
            params += words;
        }

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

        if (_debug) server.log("[W3W] " + resp.body + "(code: " + resp.statuscode + ")");
        local err = http.jsondecode(resp.body);
        local errData = {"statuscode": resp.statuscode};

        if ("error" in err) {
            errData.error <- err.error.message;
            errData.errcode <- err.error.code;
        };

        _cb(errData);
    }
}