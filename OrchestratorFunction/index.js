const df = require("durable-functions");

module.exports = df.orchestrator(function* (context) {

    const items = ["Order1", "Order2", "Order3"];

    const tasks = [];

    for (const item of items) {
        tasks.push(context.df.callActivity("ActivityFunction", item));
    }

    const results = yield context.df.Task.all(tasks);

    return results;
});