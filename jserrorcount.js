var delayedExit, proc,
    errors = [],
    file = process.argv[2],
    spawnHeadlessChromium = require('run-headless-chromium').spawn;


// Spawn headless chromium instance.
proc = spawnHeadlessChromium([file], {});


// When something is logged to the console, save it.
proc.stdout.on('data', function(data)
{
	var result = data.toString();

	// Chromium also outputs Chromium initialize errors here, so filter for JS errors.
	// JS errors in Chromium have the form of 'Uncaught TYPE: MESSAGE'
	if(result.indexOf('Uncaught') != -1)
	{
		errors.push(result);
	}
});


// Close after 5 seconds.
setTimeout(function()
{
	// Output number of JS errors.
	console.log(errors.length);

	// Kill Chromium instance.
    proc.kill('SIGINT');
}, 5000);
