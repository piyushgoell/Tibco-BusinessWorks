<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:form="http://www.example.org/interface/ap/util/ftlwhisper/v1"
    exclude-result-prefixes="form" version="1.0">

    <xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" encoding="UTF-8" indent="yes" />

    <xsl:template match="/form:Form">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>FTL Whisper</title>
                <style>
                    body {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        margin: 0;
                        padding: 0;
                        background-color: #f5f5f5;
                        color: #333;
                    }
                    .container {
                        width: 80%; /* Adjusted container width */
                        margin: 10px auto;
                        background-color: #fff;
                        padding: 40px;
                        border-radius: 8px;
                        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                    }
                    h1 {
                        text-align: center;
                        font-weight: bold;
                        font-style: italic;
                        margin-top: 0;
                        margin-bottom: 20px;
                        color: #007bff;
                        font-size: 32px; /* Increased title font size */
                    }
                    form {
                        margin: 0 auto;
                        transition: opacity 0.3s ease-in-out; /* Smooth transition */
                    }
                    form.disabled {
                        opacity: 0.5; /* Set opacity to half */
                        pointer-events: none; /* Disable pointer events */
                    }
                    label {
                        display: flex; /* Use flexbox */
                        align-items: center; /* Center items vertically */
                        font-weight: bold;
                        margin-bottom: 10px;
                        color: #555;
                        width: 30%; /* Adjusted label width */
                    }
                    input[type="checkbox"],
                    input[type="text"],
                    textarea {
                        width: 100%; /* Adjusted input width */
                        padding: 10px;
                        margin-top: 5px;
                        margin-bottom: 20px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                        box-sizing: border-box;
                        font-size: 16px;
                        color: #555;
                        background-color: #f9f9f9; /* Light gray background */
                        transition: border-color 0.3s ease-in-out; /* Smooth transition */
                    }
                    input[type="checkbox"] {
                    	width: auto;
                    }
                    input[type="text"]:focus,
                    textarea:focus {
                        border-color: #007bff; /* Change border color on focus */
                    }
                    input[type="submit"] {
                        width: 100%;
                        padding: 15px 0;
                        background-color: #007bff;
                        color: #fff;
                        border: none;
                        border-radius: 4px;
                        font-size: 16px;
                        transition: opacity 0.3s ease-in-out; /* Smooth transition */
                    }
                    input[type="submit"]:hover {
                        background-color: #0056b3;
                    }
                    input[type="submit"]:disabled {
                        opacity: 0.5; /* Set opacity to half when disabled */
                        cursor: not-allowed; /* Change cursor to not allowed */
                    }
                    .response {
                    	width: 100%;
                        margin-top: 20px;
                        border-top: 1px solid #ccc; /* Add top border */
                        padding-top: 20px; /* Add top padding */
                    }
                    .response label {
                    	width: 30%;
                        margin-bottom: 10px;
                        color: #555;
                    }
                    .response pre {
                    	width: 100%;
                        white-space: pre-wrap;
                        background-color: #f9f9f9;
                        padding: 10px;
                        border-radius: 4px;
                        border: 1px solid #ccc;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>FTL Whisper</h1>
                    <form method="post" onsubmit="submitBtn.disabled = true; return true;">
                        <div style="display: flex; justify-content: space-between;">
                            <label for="channel">Channel:</label>
                            <input type="text" name="channel" id="channel" value="{./form:Channel}" />
                        </div>

                        <div style="display: flex; justify-content: start;">
                            <label for="shouldPublished">Should Publish:</label>
                            <input type="checkbox" name="shouldPublish" id="shouldPublish" value="true"><xsl:if test="./form:ShouldPublish = 'true'"><xsl:attribute name="checked"/></xsl:if></input>
                        </div>

                        <div style="display: flex; justify-content: space-between;">
                            <label for="timeoutMSec">Timeout MSec:</label>
                            <input type="text" name="timeOutMSec" id="timeOutMSec" value="{./form:TimeOutMSec}" />
                        </div>

                        <div style="display: flex; justify-content: space-between;">
                            <label for="jwtToken">JWT Token:</label>
                            <input type="text" name="jwtToken" id="jwtToken" value="{./form:JwtToken}" />
                        </div>

                        <div style="display: flex; justify-content: space-between;">
                            <label for="requestXML">Request XML:</label>
                            <textarea name="requestXML" id="requestXML" rows="6" cols="80"><xsl:value-of select="./form:RequestXML"/></textarea>
                        </div>

                        <input type="submit" id="submitBtn" name="submitBtn" value="Submit" />
                    </form>

                    <xsl:if test="./form:ResponseTimeMsec != ''">
                        <div class="response" style="display: flex; justify-content: space-between;">
                            <label for="responseTime">Duration:</label>
                            <pre id="responseTime"><xsl:value-of select="./form:ResponseTimeMsec" />ms</pre>
                        </div>
                    </xsl:if>

                    <xsl:if test="./form:ResponseXML != ''">
                        <div class="response" style="display: flex; justify-content: space-between;">
                            <label for="responseXML">Response XML:</label>
                            <pre id="responseXML"><xsl:value-of select="./form:ResponseXML" /></pre>
                        </div>
                    </xsl:if>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
