// MIT License
//
// Copyright 2021 Twilio
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

/* DO NOT ADD YOUR CREDENTIALS TO REPO! */
const W3W_API_KEY = "@{W3W_API_KEY}";

class W3WTestCase extends ImpTestCase {

    function testInit() {

        // TEST NO CALLBACK CORRECTLY TRAPPED
        // this.assertThrowsError(W3W.init({"debug": true, "callback": "NOPE!"}), this);

        // TEST NO API KEY CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "callback": function(result) {
                    if ("error" in result) {
                        resolve();
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });
        }.bindenv(this));
    }

    function testGetWordsNullCoords() {

        // TEST BAD COORDS CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });

            W3W.getWords();
        }.bindenv(this));
    }

    function testGetWordsBadArrayCoords() {

        // TEST BAD COORD ARRAY CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });

            W3W.getWords([1]);
        }.bindenv(this));
    }

    function testGetWordsBadStringCoords() {

        // TEST BAD COORD STRING CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });

            W3W.getWords("");
        }.bindenv(this));
    }

    function testGetWordsNullStringCoords() {

        // TEST NULL COORD STRING CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });

            W3W.getWords();
        }.bindenv(this));
    }

    function testGetWordsBadLatitudeCoords() {

        // TEST BAD LATITUDE COORD CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });

            W3W.getWords("99,-0.1348044");
        }.bindenv(this));
    }

    function testGetWordsBadApiKey() {

        // TEST BAD API KEY CORRECTLY PRESENTED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getWords("51.551208,-0.1348044", true);
        }.bindenv(this));
    }

    function testGetWordsGoodKey() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        resolve(result.words);
                    }
                }
            });

            W3W.getWords("51.551208,-0.1348044");
        }.bindenv(this));
    }

    function testGetWordsGoodKeyBadLanguage() {

        // TEST BAD LANGUAGE SPECIFIER CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject(result.words);
                    }
                },
                "language": "zk"
            });

            W3W.getWords("51.551208,-0.1348044");
        }.bindenv(this));
    }

    function testGetCoordsNullString() {

        // TEST NO WORDS STRING CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords();
        }.bindenv(this));
    }

    function testGetCoordsBadString() {

        // TEST BAD WORDS STRING CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords("");
        }.bindenv(this));
    }

    function testGetCoordsBadStringSeparator() {

        // TEST BAD WORDS STRING CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords("wilson,picket,motown");
        }.bindenv(this));
    }

    function testGetCoordsBadStringTooShort() {

        // TEST BAD WORDS STRING CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords("wilson.picket");
        }.bindenv(this));
    }

    function testGetCoordsBadArrayEmpty() {

        // TEST BAD WORDS ARRAY CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords([]);
        }.bindenv(this));
    }

    function testGetCoordsBadArrayWords() {

        // TEST BAD WORDS ARRAY CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "ZARNIW00P",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords(["blue","cheese",true]);
        }.bindenv(this));
    }

    function testGetCoordsGoodArrayBadWords() {

        // TEST BAD WORDS ARRAY
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords(["blue","cheese","waldograde"]);
        }.bindenv(this));
    }

    function testGetCoordsGoodData01() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            W3W.getCoords("planet.dime.online");
        }.bindenv(this));
    }

    function testGetCoordsGoodData02() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            W3W.getCoords("planet・dime・online");
        }.bindenv(this));
    }

    function testGetWordsGoodData01() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            if ("words" in result && "coords" in result) {
                            if (result.words == "suffice.model.rigid") {
                                resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                            } else {
                                reject("Incorrect location: loss of co-ordinate precision");
                            }
                        } else {
                                reject("Incorrect location: loss of co-ordinate precision");
                            }
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            // Co-ordinates as string
            W3W.getWords("51.56278,-0.14045");
        }.bindenv(this));
    }

    function testGetWordsGoodData02() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            if (result.words == "suffice.model.rigid") {
                                resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                            } else {
                                reject("Incorrect location: loss of co-ordinate precision");
                            }
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            // Co-ordinates as array of strings
            W3W.getWords(["51.56278","-0.14045"]);
        }.bindenv(this));
    }

    function testGetWordsGoodData03() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            if (result.words == "suffice.model.rigid") {
                                resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                            } else {
                                reject("Incorrect location: loss of co-ordinate precision");
                            }
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            // Co-ordinates as array of floats
            W3W.getWords([51.56278,-0.14045]);
        }.bindenv(this));
    }

    function testGetWordsGoodData04() {

        // TEST CORRECT REQUEST AND RESPONSE -- IN GEO JSON
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            if (result.words == "overnight.velocity.washable") {
                                resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                            } else {
                                reject("Incorrect location: loss of co-ordinate precision");
                            }
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            // Co-ordinates as ints
            W3W.getWords([51,0]);
        }.bindenv(this));
    }

    function testGetWordsGoodDataGeoJson01() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            if ("words" in result && "coords" in result) {
                            if (result.words == "suffice.model.rigid") {
                                resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                            } else {
                                reject("Incorrect location: loss of co-ordinate precision");
                            }
                        } else {
                                reject("Incorrect location: loss of co-ordinate precision");
                            }
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            // Co-ordinates as string -- and expect response in GeoJSON format
            W3W.getWords("51.56278,-0.14045", true);
        }.bindenv(this));
    }

    function testGetWordsGoodDataGeoJson02() {

        // TEST CORRECT REQUEST AND RESPONSE -- IN GEO JSON
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": W3W_API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode + ", status: " + result.statuscode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            if (result.words == "suffice.model.rigid") {
                                resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                            } else {
                                reject("Incorrect location: loss of co-ordinate precision");
                            }
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            // Co-ordinates as array of strings -- and expect response in GeoJSON format
            W3W.getWords(["51.56278","-0.14045"], true);
        }.bindenv(this));
    }

}
