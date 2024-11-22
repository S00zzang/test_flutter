// Authorization token that must have been created previously. See : https://developer.spotify.com/documentation/web-api/concepts/authorization
const token = 'BQAPmid8NPFJwbZqO1HIcWQApN06DJeGxcKZK8-hk47TFkQl-B5HMzujwstq-gjn9VhWAF_dhicr2xlr8_ZnDF3gUCLO06Q2nRWnAd1DSSVLcj46Iffktj7CF9hgk4gzQPFllDCvwxLxJYbpy75vSPSbPzmx2TAJvPBAViQhBtEpiTURM0iXZxqT-x_vMHQU0OR5am-W2Vq1cG278x3N2xjcXSQVL2Lc3OSGNBl19HPkrWHzc7kNLypXOQQvUK11J65xqgE0ppIKxHOVWU6EFJHU1j9LAAqYWoEP';
async function fetchWebApi(endpoint, method, body) {
  const res = await fetch(`https://api.spotify.com/${endpoint}`, {
    headers: {
      Authorization: `Bearer ${token}`,
    },
    method,
    body:JSON.stringify(body)
  });
  return await res.json();
}

async function getTopTracks(){
  // Endpoint reference : https://developer.spotify.com/documentation/web-api/reference/get-users-top-artists-and-tracks
  return (await fetchWebApi(
    'v1/me/top/tracks?time_range=long_term&limit=5', 'GET'
  )).items;
}

const topTracks = await getTopTracks();
console.log(
  topTracks?.map(
    ({name, artists}) =>
      `${name} by ${artists.map(artist => artist.name).join(', ')}`
  )
);