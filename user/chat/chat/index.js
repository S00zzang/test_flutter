const express = require('express');
const axios = require('axios');
const cors = require('cors'); // CORS 패키지 임포트

const app = express();
const port = 3000;

app.use(cors()); // CORS 미들웨어를 사용

// Spotify API 액세스 토큰 (이 값은 실제 토큰으로 교체해야 함)
const token = 'BQAJfMSLUE3sUyU-o3ObU1-DCcysJSai9SyCnSUt79dnnnVLmZHYzh0QOuor_Q7BEE_CRcpqWsiQI9qDVZFkRbuRX4VYfuozFVOfsUqA_4Z7azx3G2k';  // 여기에 본인의 Spotify Access Token을 넣으세요

// Spotify API 요청을 프록시하는 엔드포인트
app.get('/spotify', async (req, res) => {
  const query = req.query.q;  // 쿼리 파라미터로 전달된 검색어

  if (!query) {
    return res.status(400).send('Query parameter "q" is required');
  }

  try {
    // Spotify API에 요청 보내기
    const response = await axios.get('https://api.spotify.com/v1/search', {
      params: {
        q: query,  // 검색어
        type: 'track',  // 검색할 타입 (track은 노래)
        limit: 5,  // 최대 5개의 결과
      },
      headers: {
        Authorization: `Bearer ${token}`,  // Spotify Access Token
      },
    });

    // 받은 데이터를 클라이언트에 반환
    console.log('Spotify API Response:', response.status, response.data);  // 응답 상태와 데이터 로그
    res.json(response.data);
  } catch (error) {
    // Spotify API 호출 실패 시 에러 로그 및 응답
    if (error.response) {
      // 서버로부터 응답을 받은 경우
      console.error('Error during Spotify API request:', error.response.status, error.response.data);
      res.status(error.response.status).send(`Spotify API Error: ${error.response.data.error.message}`);
    } else if (error.request) {
      // 서버에 요청을 보냈지만 응답을 받지 못한 경우
      console.error('Error during Spotify API request - No response received:', error.request);
      res.status(500).send('Spotify API Error: No response from the server.');
    } else {
      // 요청을 설정하는 동안 발생한 오류
      console.error('Error during Spotify API request:', error.message);
      res.status(500).send(`Spotify API Error: ${error.message}`);
    }
  }
});

// 서버 시작
app.listen(port, () => {
  console.log(`Server running at http://0.0.0.0:${port}`);
});
