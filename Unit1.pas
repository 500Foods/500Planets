unit Unit1;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, Vcl.Controls, Vcl.StdCtrls, WEBLib.StdCtrls;

type
  TForm1 = class(TWebForm)
    WebButton1: TWebButton;
    procedure WebButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.WebButton1Click(Sender: TObject);
begin

  asm
    console.log('500Planets');


function createDayContainer(heavenlyData, width, height, skyColors, observer) {
    // Create the main day container
    const dayContainer = document.createElement('div');
    dayContainer.classList.add('day');
    dayContainer.style.backgroundColor = 'black';
    dayContainer.style.position = 'relative';
    dayContainer.style.width = width;
    dayContainer.style.height = height;
    dayContainer.style.overflow = 'hidden';

    // Create the horizon line
    const horizonLine = document.createElement('div');
    horizonLine.classList.add('horizon');
    horizonLine.style.position = 'absolute';
    horizonLine.style.width = '100%';
    horizonLine.style.height = '1px';
    horizonLine.style.backgroundColor = 'white';
    horizonLine.style.top = '75%';
    horizonLine.style.zIndex = '15';

    // Create the sky gradient
    const skyGradient = document.createElement('div');
    skyGradient.classList.add('sky-gradient');
    skyGradient.style.position = 'absolute';
    skyGradient.style.top = '0';
    skyGradient.style.left = '0';
    skyGradient.style.width = '100%';
    skyGradient.style.height = '75%';
    skyGradient.style.backgroundImage = getSkyGradient(heavenlyData.Summary, skyColors);
    skyGradient.style.zIndex = '5';

    // Create the under-horizon div
    const underHorizon = document.createElement('div');
    underHorizon.classList.add('under-horizon');
    underHorizon.style.position = 'absolute';
    underHorizon.style.top = '75%';
    underHorizon.style.left = '0';
    underHorizon.style.width = '100%';
    underHorizon.style.height = '25%';
    underHorizon.style.backgroundColor = 'black';
    underHorizon.style.zIndex = '10';

    const underHorizonGradient = document.createElement('div');
    underHorizonGradient.classList.add('under-horizon-gradient');
    underHorizonGradient.style.position = 'absolute';
    underHorizonGradient.style.top = '75%';
    underHorizonGradient.style.left = '0';
    underHorizonGradient.style.width = '100%';
    underHorizonGradient.style.height = '25%';
    underHorizonGradient.style.backgroundImage = 'linear-gradient(to bottom, rgba(0, 0, 0, 0.75), black)';
    underHorizonGradient.style.zIndex = '50';

    // Append the elements to the day container
    dayContainer.appendChild(horizonLine);
    dayContainer.appendChild(skyGradient);
    dayContainer.appendChild(underHorizon);
    dayContainer.appendChild(underHorizonGradient);

    // Add the day container to the page
    document.body.appendChild(dayContainer);

    return dayContainer;
}

function getSkyGradient(summaryData, skyColors) {
    const {
        SearchDate,
        SunRise,
        SunSet,
        CivilDawn,
        CivilDusk,
        NauticalDawn,
        NauticalDusk,
        AstronomicalDawn,
        AstronomicalDusk,
        SolarNoon
    } = summaryData;

    const searchDateTime = luxon.DateTime.fromISO(SearchDate);
    const totalDayDuration = 24 * 60 * 60 * 1000;

    const getPercentage = (isoTime) => {
        const eventTime = luxon.DateTime.fromISO(isoTime);
        const eventDiff = eventTime.diff(searchDateTime).as('milliseconds');
        return (eventDiff / totalDayDuration * 100);
    };

    return 'linear-gradient(to right,' +
        skyColors[0] + ' 0%,' +
        skyColors[0] + ' ' + getPercentage(AstronomicalDawn.Time) + '%,' +
        skyColors[1] + ' ' + getPercentage(NauticalDawn.Time) + '%,' +
        skyColors[2] + ' ' + getPercentage(CivilDawn.Time) + '%,' +
        skyColors[3] + ' ' + getPercentage(SunRise.Time) + '%,' +
        skyColors[4] + ' ' + getPercentage(SolarNoon.Time) + '%,' +
        skyColors[3] + ' ' + getPercentage(SunSet.Time) + '%,' +
        skyColors[2] + ' ' + getPercentage(CivilDusk.Time) + '%,' +
        skyColors[1] + ' ' + getPercentage(NauticalDusk.Time) + '%,' +
        skyColors[0] + ' ' + getPercentage(AstronomicalDusk.Time) + '%,' +
        skyColors[0] + ' 100%)';
}

function displayHeavenlyBody(dayContainer, heavenlyData, bodyName, color, diameter, intervalMinutes = 1) {
    if (!heavenlyData[bodyName]) {
        throw new Error(`Heavenly body '${bodyName}' not found in the data.`);
    }

    const data = heavenlyData[bodyName];
    const width = dayContainer.offsetWidth;
    const height = dayContainer.offsetHeight;
    const horizonY = height * 0.75;

    data.forEach(entry => {
        const angle = entry.direction;
        const elevation = entry.elevation;

        const x = (angle / 360) * width - (diameter / width) * width / 2;
        const y = horizonY - (elevation / 90) * horizonY - (diameter / height) * height / 2;

        const bodyElement = document.createElement('div');
        bodyElement.classList.add('heavenly-body');
        bodyElement.style.position = 'absolute';
        bodyElement.style.left = `${x}px`;
        bodyElement.style.top = `${y}px`;
        bodyElement.style.width = `${(diameter / width) * 100}%`;
        bodyElement.style.height = `${(diameter / height) * 100}%`;
        bodyElement.style.borderRadius = '50%';
        bodyElement.style.backgroundColor = color;
        bodyElement.style.zIndex = '40';

        dayContainer.appendChild(bodyElement);
    });
}

function addAreaForBody(dayContainer, heavenlyData, bodyName, width, height, color, gradientColor, intervalMinutes = 1) {
    if (!heavenlyData[bodyName]) {
        throw new Error('Heavenly body \'' + bodyName + '\' not found in the data.');
    }

    const areaData = heavenlyData[bodyName];

    // Create an SVG element
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.style.position = 'absolute';
    svg.style.top = '0';
    svg.style.left = '0';
    svg.style.width = width;
    svg.style.height = height;
    svg.style.zIndex = '5';

    // Create a path element
    const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('d', '');
    path.style.fill = 'url(#gradient-' + bodyName + ')';

    // Create a linear gradient
    const gradient = document.createElementNS('http://www.w3.org/2000/svg', 'linearGradient');
    gradient.id = 'gradient-' + bodyName;
    gradient.setAttribute('x1', '0%');
    gradient.setAttribute('y1', '100%');
    gradient.setAttribute('x2', '0%');
    gradient.setAttribute('y2', '0%');

    const stop1 = document.createElementNS('http://www.w3.org/2000/svg', 'stop');
    stop1.setAttribute('offset', '0%');
    stop1.setAttribute('style', 'stop-color:' + gradientColor + ';stop-opacity:1');

    const stop2 = document.createElementNS('http://www.w3.org/2000/svg', 'stop');
    stop2.setAttribute('offset', '100%');
    stop2.setAttribute('style', 'stop-color:' + color + ';stop-opacity:1');

    // Build the path data
    let d = 'M 0 ' + parseInt(height);

    for (let i = 0; i < areaData.length; i++) {
        const entry = areaData[i];
        if (entry.Altitude >= 0) {
          const x = (i / areaData.length) * parseInt(width);
          const y = (0.75*parseInt(height)) - 2*((entry.Altitude / 180) * parseInt(height))
          d += ' L ' + x + ' ' + y;
        }
    }

    d += ' L ' + parseInt(width) + ' ' + parseInt(height) + ' L 0 ' + parseInt(height) + ' Z';

    path.setAttribute('d', d);
    gradient.appendChild(stop1);
    gradient.appendChild(stop2);
    svg.appendChild(gradient);
    svg.appendChild(path);
    dayContainer.appendChild(svg);

    return svg;
}

function addLineForBody(dayContainer, heavenlyData, bodyName, width, height, color, intervalMinutes = 1) {
    if (!heavenlyData[bodyName]) {
        throw new Error(`Heavenly body '${bodyName}' not found in the data.`);
    }

    const lineData = heavenlyData[bodyName];

    // Create an SVG element
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.style.position = 'absolute';
    svg.style.overflow = 'visible';
    svg.style.top = '0';
    svg.style.left = '0';
    svg.style.width = width;
    svg.style.height = height;
    svg.style.zIndex = '20';

    // Create a path element
    const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('d', '');
    path.style.fill = 'none';
    path.style.stroke = color;
    path.style.strokeWidth = '1px';

    // Build the path data
    let d = '';

    for (let i = 0; i < lineData.length; i++) {
        const entry = lineData[i];
        const x = (i / lineData.length) * parseInt(width);
        const y = (0.75*parseInt(height)) - 2*((entry.Altitude / 180) * parseInt(height))

        if (i === 0) {
            d += `M ${x} ${y}`;
        } else {
            d += ` L ${x} ${y}`;
        }
    }

    path.setAttribute('d', d);

    svg.appendChild(path);
    dayContainer.appendChild(svg);

    return svg;
}

function getHeavenlyData(date, latitude, longitude, altitude, timezone, intervalMinutes = 1, bodies = ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn']) {
    const observer = new Astronomy.Observer(latitude, longitude, altitude);
    const localDate = luxon.DateTime.fromJSDate(date).setZone(timezone);
    const startDate = localDate.startOf('day').toJSDate();
    const endDate = localDate.endOf('day').toJSDate();

    const result = {
        Observer: {
            Latitude: latitude,
            Longitude: longitude,
            Altitude: altitude,
            Timezone: timezone
        },
        Summary: {
            SearchDate: startDate.toISOString(),
            NoonDate: new Date(startDate.getTime() + (12 * 60 * 60 * 1000)).toISOString()
        }
    };

    const numIntervals = Math.round(24 * 60 / intervalMinutes);
    let maxSunAngle = 0;
    let maxSunAngleTime = null;

    function observation(obsDate, observer, body) {
      const equatorial = Astronomy.Equator(body, obsDate, observer, true, true);
      const horizontal = Astronomy.Horizon(obsDate, observer, equatorial.ra, equatorial.dec, 'normal');

            if (body === 'Sun') {
                if (horizontal.altitude > maxSunAngle) {
                    maxSunAngle = horizontal.altitude;
                    maxSunAngleTime = obsDate;
                }
            }

      return {
        Time: obsDate.toISOString(),
        Altitude: horizontal.altitude,
        Azimuth: horizontal.azimuth
      }
    }

    for (let body of bodies) {
        result[body] = [];
        for (let i = 0; i < numIntervals; i++) {
            const currentDate = new Date(startDate.getTime() + i * intervalMinutes * 60000);
            result[body].push(observation(currentDate, observer, body));
        }
    }

    result.Summary.SunRise          = observation(Astronomy.SearchAltitude(Astronomy.Body.Sun, observer, +1, startDate, 300,   0).date, observer, Astronomy.Body.Sun);
    result.Summary.SunSet           = observation(Astronomy.SearchAltitude(Astronomy.Body.Sun, observer, -1, startDate, 300,   0).date, observer, Astronomy.Body.Sun);
    result.Summary.CivilDawn        = observation(Astronomy.SearchAltitude(Astronomy.Body.Sun, observer, +1, startDate, 300,  -6).date, observer, Astronomy.Body.Sun);
    result.Summary.CivilDusk        = observation(Astronomy.SearchAltitude(Astronomy.Body.Sun, observer, -1, startDate, 300,  -6).date, observer, Astronomy.Body.Sun);
    result.Summary.NauticalDawn     = observation(Astronomy.SearchAltitude(Astronomy.Body.Sun, observer, +1, startDate, 300, -12).date, observer, Astronomy.Body.Sun);
    result.Summary.NauticalDusk     = observation(Astronomy.SearchAltitude(Astronomy.Body.Sun, observer, -1, startDate, 300, -12).date, observer, Astronomy.Body.Sun);
    result.Summary.AstronomicalDawn = observation(Astronomy.SearchAltitude(Astronomy.Body.Sun, observer, +1, startDate, 300, -18).date, observer, Astronomy.Body.Sun);
    result.Summary.AstronomicalDusk = observation(Astronomy.SearchAltitude(Astronomy.Body.Sun, observer, -1, startDate, 300, -18).date, observer, Astronomy.Body.Sun);
    result.Summary.MoonRise         = observation(Astronomy.SearchAltitude(Astronomy.Body.Moon, observer, +1, startDate, 300,   0).date, observer, Astronomy.Body.Moon);
    result.Summary.MoonSet          = observation(Astronomy.SearchAltitude(Astronomy.Body.Moon, observer, -1, startDate, 300,   0).date, observer, Astronomy.Body.Moon);
    result.Summary.SolarNoon        = observation(maxSunAngleTime, observer, Astronomy.Body.Sun);

    console.log(result.Summary);

    return result;
}

function generateHeavenlyBody(dayContainer, heavenlyData, bodyName, color, diameter, time) {
    if (!heavenlyData[bodyName]) {
        throw new Error('Heavenly body \'' + bodyName + '\' not found in the data.');
    }

    const data = heavenlyData[bodyName];
    const width = dayContainer.offsetWidth;
    const height = dayContainer.offsetHeight;
    const horizonY = height * 0.75;

    // Find the index of the data point closest to the given time
    let closestIndex = 0;
    let closestDiff = Infinity;
    for (let i = 0; i < data.length; i++) {
        const diff = Math.abs(new Date(data[i].Time).getTime() - new Date(time).getTime());
        if (diff < closestDiff) {
            closestIndex = i;
            closestDiff = diff;
        }
    }

    const entry = data[closestIndex];
    const azimuth = entry.Azimuth;
    const altitude = entry.Altitude;

    const x = (azimuth / 360) * width - diameter / 2;
    const y = horizonY - (altitude / 90) * horizonY - diameter / 2;

    const bodyElement = document.createElement('div');
    bodyElement.classList.add('heavenly-body',bodyName);
    bodyElement.style.position = 'absolute';
    bodyElement.style.left = `${x}px`;
    bodyElement.style.top = `${y}px`;
    bodyElement.style.width = `${diameter}px`;
    bodyElement.style.height = `${diameter}px`;
    bodyElement.style.borderRadius = '50%';
    bodyElement.style.backgroundColor = color;
    bodyElement.style.zIndex = '40';

    dayContainer.appendChild(bodyElement);

    return bodyElement;
}

function startAnimation(dayContainer, heavenlyData, bodyName, element, actualWidth, actualHeight, duration = 5000, fps = 24) {
    if (!heavenlyData[bodyName]) {
        throw new Error('Heavenly body \'' + bodyName + '\' not found in the data.');
    }

    const data = heavenlyData[bodyName];

    function updateKeyframes() {
        const keyframes = [`@keyframes move-${bodyName} {`];
        const numFrames = Math.floor(duration / 1000 * fps);
        const increment = data.length / numFrames;

        for (let i = 0; i <= numFrames; i++) {
            const index = Math.floor(i * increment);
            const entry = data[index];

            if (entry) {
                const x = (index / data.length) * parseInt(actualWidth);
                const y = (0.75 * parseInt(actualHeight)) - 2.5 * ((entry.Altitude / 180) * parseInt(actualHeight));

                const percentage = (i / numFrames) * 100;
                keyframes.push(`${percentage}% { left: ${x}px; top: ${y}px; }`);
            }
        }

        keyframes.push('}');

        const style = document.createElement('style');
        style.textContent = keyframes.join('\n');
        dayContainer.appendChild(style);
    }

    updateKeyframes();

    // Remove any existing transitions
    element.style.transition = 'none';

    // Reset the initial position
    const firstEntry = data[0];
    const firstX = (0 / data.length) * parseInt(actualWidth);
    const firstY = (0.75 * parseInt(actualHeight)) - 2 * ((firstEntry.Altitude / 180) * parseInt(actualHeight));
    element.style.left = `${firstX}px`;
    element.style.top = `${firstY}px`;

    element.style.animation = `move-${bodyName} ${duration}ms linear infinite`;
    element.style.animationPlayState = 'running';

    const handleResize = () => {
        element.style.animationPlayState = 'paused';
        updateKeyframes();
        element.style.animation = `move-${bodyName} ${duration}ms linear infinite`;
        element.style.animationPlayState = 'running';
    };

    window.addEventListener('resize', handleResize);

    return {
        stop: () => {
            element.style.animationPlayState = 'paused';
            window.removeEventListener('resize', handleResize);
        }
    };
}

function addSunriseSunsetCircles(dayContainer, summaryData, skyColors) {
    const { SearchDate, NoonDate, AstronomicalDawn, NauticalDawn, CivilDawn, SunRise, SunSet, SolarNoon, CivilDusk, NauticalDusk, AstronomicalDusk } = summaryData;
    const dayRect = dayContainer.getBoundingClientRect();
    const dayWidth = dayRect.width;

    const timesOfInterest = [
        { className: 'astro-r', time: AstronomicalDawn.Time, color: skyColors[0] },
        { className: 'naut-r',  time: NauticalDawn.Time, color: skyColors[1] },
        { className: 'civil-r', time: CivilDawn.Time, color: skyColors[2] },
        { className: 'sunrise', time: SunRise.Time, color: skyColors[3] },
        { className: 'noon',    time: NoonDate, color: skyColors[6] },
        { className: 'solnoon', time: SolarNoon.Time, color: skyColors[5] },
        { className: 'sunset',  time: SunSet.Time, color: skyColors[3] },
        { className: 'civil-s', time: CivilDusk.Time, color: skyColors[2] },
        { className: 'naut-s',  time: NauticalDusk.Time, color: skyColors[1] },
        { className: 'astro-s', time: AstronomicalDusk.Time, color: skyColors[0] },
    ];

    timesOfInterest.forEach(({ className, time, color }) => {
        const circle = document.createElement('div');
        circle.classList.add('horizon-circle', className);
        circle.style.position = 'absolute';
        circle.style.zIndex = '60';
        circle.style.background = color;
        circle.style.top = '75%';

        const percentage = luxon.DateTime.fromISO(time).diff(luxon.DateTime.fromISO(summaryData.SearchDate)).as('milliseconds') / 86400000;
        circle.style.left = (percentage * dayWidth) + 'px';

        dayContainer.appendChild(circle);
    });
}

function addSunRiseSetTimes(dayContainer, summaryData) {
    const { SearchDate, NoonDate, AstronomicalDawn, NauticalDawn, CivilDawn, SunRise, SunSet, SolarNoon, CivilDusk, NauticalDusk, AstronomicalDusk } = summaryData;

    const createTimeElement = (label, time, className) => {
        const timeElement = document.createElement('div');
        timeElement.classList.add('sun-rise-set-time', className);
        timeElement.innerHTML = `<span class="label">${label}</span> <span class="time">${luxon.DateTime.fromISO(time).toFormat('HH:mm')}</span>`;
        return timeElement;
    };

    const sunriseTimesElement = document.createElement('div');
    sunriseTimesElement.classList.add('sun-rise-set-times', 'sunrise-times');
    sunriseTimesElement.style.position = 'absolute';
    sunriseTimesElement.style.left = '10px';
    sunriseTimesElement.style.bottom = '10px';
    sunriseTimesElement.style.zIndex = '80';

    sunriseTimesElement.appendChild(createTimeElement('SunRise', SunRise.Time, 'sunrise'));
    sunriseTimesElement.appendChild(createTimeElement('Civil', CivilDawn.Time, 'civil'));
    sunriseTimesElement.appendChild(createTimeElement('Naut', NauticalDawn.Time, 'nautical'));
    sunriseTimesElement.appendChild(createTimeElement('Astro', AstronomicalDawn.Time, 'astronomical'));

    const sunsetTimesElement = document.createElement('div');
    sunsetTimesElement.classList.add('sun-rise-set-times', 'sunset-times');
    sunsetTimesElement.style.position = 'absolute';
    sunsetTimesElement.style.right = '10px';
    sunsetTimesElement.style.bottom = '10px';
    sunsetTimesElement.style.zIndex = '80';

    sunsetTimesElement.appendChild(createTimeElement('SunSet', SunSet.Time, 'sunset'));
    sunsetTimesElement.appendChild(createTimeElement('Civil', CivilDusk.Time, 'civil'));
    sunsetTimesElement.appendChild(createTimeElement('Naut', NauticalDusk.Time, 'nautical'));
    sunsetTimesElement.appendChild(createTimeElement('Astro', AstronomicalDusk.Time, 'astronomical'));

    dayContainer.appendChild(sunriseTimesElement);
    dayContainer.appendChild(sunsetTimesElement);

    const createDurationElement = (label, startTime, endTime, className) => {
        const duration = luxon.DateTime.fromISO(endTime).diff(luxon.DateTime.fromISO(startTime)).as('hours');
        const hours = Math.floor(duration);
        const minutes = Math.round((duration - hours) * 60);
        const formattedDuration = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;

        const durationElement = document.createElement('div');
        durationElement.classList.add('sun-rise-set-duration', className);
        durationElement.innerHTML = `<span class="label">${label}</span> <span class="duration">${formattedDuration}</span>`;
        return durationElement;
    };

    sunriseTimesElement.appendChild(createDurationElement('Day Length', SunRise.Time, SunSet.Time, 'day-length'));
    sunsetTimesElement.appendChild(createDurationElement('Night Length', SunSet.Time, SunRise.Time, 'night-length'));

}

function addDate(dayContainer, summaryData) {
    const dateElement = document.createElement('div');
    dateElement.classList.add('date');
    dateElement.style.position = 'absolute';
    dateElement.style.left = '10px';
    dateElement.style.top = '10px';
    dateElement.style.zIndex = '80';
    dateElement.style.fontSize = '24px';

    const date = luxon.DateTime.fromISO(summaryData.SearchDate).toFormat('d');
    dateElement.textContent = date;

    dayContainer.appendChild(dateElement);
}

function addSolarNoonInfo(dayContainer, summaryData) {
    const solarNoonElement = document.createElement('div');
    solarNoonElement.classList.add('solar-noon-info');
    solarNoonElement.style.position = 'absolute';
    solarNoonElement.style.left = '50%';
    solarNoonElement.style.bottom = '10px';
    solarNoonElement.style.transform = 'translateX(-50%)';
    solarNoonElement.style.zIndex = '80';

    const createInfoElement = (label, value) => {
        const infoElement = document.createElement('div');
        infoElement.innerHTML = `<span class="label">${label}</span> <span class="value">${value}</span>`;
        return infoElement;
    };

    solarNoonElement.appendChild(createInfoElement('Solar Noon', luxon.DateTime.fromISO(summaryData.SolarNoon.Time).toFormat('HH:mm')));
    solarNoonElement.appendChild(createInfoElement('Azimuth', summaryData.SolarNoon.Azimuth.toFixed(2)));
    solarNoonElement.appendChild(createInfoElement('Altitude', summaryData.SolarNoon.Altitude.toFixed(2)));

    dayContainer.appendChild(solarNoonElement);
}

function addAnimationTime(dayContainer, heavenlyData) {
    const animationTimeElement = document.createElement('div');
    animationTimeElement.classList.add('animation-time');
    animationTimeElement.style.position = 'absolute';
    animationTimeElement.style.right = '10px';
    animationTimeElement.style.top = '10px';
    animationTimeElement.style.zIndex = '80';
    animationTimeElement.style.display = 'none';

    dayContainer.appendChild(animationTimeElement);

    let animationStartTime;

    const updateAnimationTime = () => {
        const elapsedTime = Date.now() - animationStartTime;
        const animationTime = luxon.DateTime.fromISO(heavenlyData.Summary.SearchDate).plus({ milliseconds: elapsedTime });
        animationTimeElement.textContent = animationTime.toFormat('HH:mm:ss');
        requestAnimationFrame(updateAnimationTime);
    };

    return {
        start: () => {
            animationStartTime = Date.now();
            animationTimeElement.style.display = 'block';
            updateAnimationTime();
        },
        stop: () => {
            animationTimeElement.style.display = 'none';
        }
    };
}

function createAstronomyDisplay(options) {
    const defaultOptions = {
        date: new Date(),
        latitude: 0,
        longitude: 0,
        altitude: 0,
        timezone: 'UTC',
        width: '800px',
        height: '400px',
        skyColors: ['black', '#000020', '#000050', '#000080', 'skyblue', '#FDB813', '#feedc4'],
        components: {
            Sun: {
                animation: true,
                area: true,
                line: true
            },
            Moon: {
                animation: true,
                line: true
            },
            date: true,
            sunRiseSetTimes: true,
            solarNoonInfo: true,
            animationTime: true
        }
    };

    const { date, latitude, longitude, altitude, timezone, width, height, skyColors, components } = { ...defaultOptions, ...options };

    const containerId = `astronomy-container-${Date.now()}`;
    const container = document.createElement('div');
    container.id = containerId;
    container.style.width = width;
    container.style.height = height;
    document.body.appendChild(container);

    const containerRect = container.getBoundingClientRect();
    const actualWidth = `${containerRect.width}px`;
    const actualHeight = `${containerRect.height}px`;

    const bodies = Object.keys(components).filter(key => key !== 'date' && key !== 'sunRiseSetTimes' && key !== 'solarNoonInfo' && key !== 'animationTime');
    const intervalMinutes = 1;
    const heavenlyData = getHeavenlyData(date, latitude, longitude, altitude, timezone, intervalMinutes, bodies);

    const dayContainer = createDayContainer(heavenlyData, actualWidth, actualHeight, skyColors);
    container.appendChild(dayContainer);

    addSunriseSunsetCircles(dayContainer, heavenlyData.Summary, skyColors);

    if (components.date) {
        addDate(dayContainer, heavenlyData.Summary);
    }

    if (components.sunRiseSetTimes) {
        addSunRiseSetTimes(dayContainer, heavenlyData.Summary);
    }

    if (components.solarNoonInfo) {
        addSolarNoonInfo(dayContainer, heavenlyData.Summary);
    }

    const bodyElements = {};

    for (const body of bodies) {
        if (components[body].area) {
            addAreaForBody(dayContainer, heavenlyData, body, actualWidth, actualHeight, 'rgba(255, 255, 0, 0.4)', 'rgba(255, 255, 0, 0.1)');
        }

        if (components[body].line) {
            addLineForBody(dayContainer, heavenlyData, body, actualWidth, actualHeight, 'rgba(255, 255, 0, 0.4)');
        }

        if (components[body].animation) {
            const color = body === 'Sun' ? '#FDB813' : 'silver';
            bodyElements[body] = generateHeavenlyBody(dayContainer, heavenlyData, body, color, 25, date.toISOString());
        }
    }

    const animations = {};
    const animationTimes = {};

    for (const body of bodies) {
        if (components[body].animation && bodyElements[body]) {
            animations[body] = startAnimation(dayContainer, heavenlyData, body, bodyElements[body], actualWidth, actualHeight, 30000, 1);
        }
    }

    if (components.animationTime) {
        animationTimes.sun = addAnimationTime(dayContainer, heavenlyData);
        animationTimes.sun.start();
    }

    return {
        container: container,
        animations: animations,
        animationTimes: animationTimes
    };
}

// Get today's date
const today = new Date();

// Define the common options for all three displays
const commonOptions = {
    latitude: 49.264444,
    longitude: -123.139444,
    altitude: 40,
    timezone: 'America/Vancouver',
    width: '200px',
    height: '100px',
    components: {
        Sun: {
//            animation: true,
            line: true
        },
        Moon: {
//            animation: true,
            area: true,
            line: true
        },
        date: false,
        sunRiseSetTimes: false,
        solarNoonInfo: false,
        animationTime: false
    }
};

for (var i = 0; i < 30; i++) {

const newday = new Date();
newday.setDate(newday.getDate() + i*10);
const Options = {
    ...commonOptions,
    date: newday
};
createAstronomyDisplay(Options);
}


  end;

end;

end.