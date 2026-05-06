exports.handler = async (event) => {
    console.log("Incoming event:", JSON.stringify(event));

    const name = event.queryStringParameters?.name || "Unknown";

    const response = {
        message: `I'm not ${name.toUpperCase()} ...you are. FROM NODE!`,
    };

    console.log("Response:", JSON.stringify(response));

    return {
        statusCode: 200,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(response),
    };
};