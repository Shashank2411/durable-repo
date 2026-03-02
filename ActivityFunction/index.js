module.exports = async function (context) {

    const input = context.bindings.name;

    context.log(`Processing ${input}`);

    await new Promise(resolve => setTimeout(resolve, 2000));

    return `Completed ${input}`;
};