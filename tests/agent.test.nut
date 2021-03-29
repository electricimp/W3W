class W3WTestCase extends ImpTestCase {

    /* DO NOT ADD TO REPO! */
    API_KEY = "<YOUR_API_KEY>";

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
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });

            W3W.getWords();
        }.bindenv(this));
    }

    function testGetWordsBadArrayCoords() {

        // TEST BAD COORDS CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });

            W3W.getWords([1]);
        }.bindenv(this));
    }

    function testGetWordsBadStringCoords() {

        // TEST BAD COORDS CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }.bindenv(this)
            });

            W3W.getWords("");
        }.bindenv(this));
    }

    function testGetWordsBadLattiCoords() {

        // TEST BAD COORDS CORRECTLY TRAPPED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": API_KEY,
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

    function testGetWordsBadKey() {

        // TEST BAD API KEY CORRECTLY PRESENTED
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getWords("51.551208,-0.1348044");
        }.bindenv(this));
    }

    function testGetWordsGoodKey() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode);
                    } else {
                        resolve(result.words);
                    }
                }
            });

            W3W.getWords("51.551208,-0.1348044");
            //W3W.getWords("51.330677,00.0080789");
        }.bindenv(this));
    }

    function testGetWordsGoodKeyBadLang() {

        // TEST CORRECT REQUEST AND RESPONSE
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject(result.words);
                    }
                },
                "language": "zk"
            });

            W3W.getWords("51.551208,-0.1348044");
        }.bindenv(this));
    }

    function testGetCoordsNullWords() {

        // TEST BAD WORDS STRING
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords();
        }.bindenv(this));
    }

    function testGetCoordsBadString() {

        // TEST BAD WORDS STRING
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords("");
        }.bindenv(this));
    }

    function testGetCoordsBadArray() {

        // TEST BAD WORDS ARRAY
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords([]);
        }.bindenv(this));
    }

    function testGetCoordsBadArrayWords() {

        // TEST BAD WORDS ARRAY
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords(["blue","cheese",true]);
        }.bindenv(this));
    }

    function testGetCoordsBadArrayWords() {

        // TEST BAD WORDS ARRAY
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": "TEST-FARTZ",
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords(["blue","cheese",true]);
        }.bindenv(this));
    }

    function testGetCoordsBadWords() {

        // TEST BAD WORDS ARRAY
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        resolve(result.error + ", code: " + result.errcode);
                    } else {
                        reject();
                    }
                }
            });

            W3W.getCoords(["blue","cheese","waldograde"]);
        }.bindenv(this));
    }

    function testGetCoordsGoodData01() {

        // TEST BAD WORDS ARRAY
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            W3W.getWords("51.55123,-0.13460");
        }.bindenv(this));
    }

    function testGetCoordsGoodData02() {

        // TEST BAD WORDS ARRAY
        return Promise(function(resolve, reject) {
            W3W.init({
                "apiKey": API_KEY,
                "callback": function(result) {
                    if ("error" in result) {
                        reject(result.error + ", code: " + result.errcode);
                    } else {
                        if ("words" in result && "coords" in result) {
                            resolve(result.words + " -> " + result.coords.latitude + "," + result.coords.longitude);
                        } else {
                            reject("Missing keys in data");
                        }
                    }
                }
            });

            W3W.getWords("51.56278,-0.14045");
        }.bindenv(this));
    }

}