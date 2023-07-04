package com.icia.web.service;

import java.net.URI;
import java.net.URISyntaxException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.icia.web.dao.CtBoardDao;
import com.icia.web.model.CtPm;
import com.icia.web.model.FdPm;
import com.icia.web.model.Kakao.KakaoPayApprove;
import com.icia.web.model.Kakao.KakaoPayOrder;
import com.icia.web.model.Kakao.KakaoPayReady;


@Service("kakaoPayService")
public class KakaoPayService 
{
	private static Logger logger = LoggerFactory.getLogger(KakaoPayService.class);
	
	//카카오페이 호스트
	@Value("#{env['kakao.pay.host']}")
	private String KAKAO_PAY_HOST;
	
	//관리자 키
	@Value("#{env['kakao.pay.admin.key']}")
	private String KAKAO_PAY_ADMIN_KEY;
	
	//가맹점 코드, 10자
	@Value("#{env['kakao.pay.cid']}")
	private String KAKAO_PAY_CID;
	
	//결제 URL
	@Value("#{env['kakao.pay.ready.url']}")
	private String KAKAO_PAY_READY_URL;
	
	//결제 요청 URL
	@Value("#{env['kakao.pay.approve.url']}")
	private String KAKAO_PAY_APPROVE_URL;
	
	//결제 성공 URL
	@Value("#{env['kakao.pay.success.url']}")
	private String KAKAO_PAY_SUCCESS_URL;
	
	//결제 취소 URL
	@Value("#{env['kakao.pay.cancel.url']}")
	private String KAKAO_PAY_CANCEL_URL;
	
	//결제 실패 URL
	@Value("#{env['kakao.pay.fail.url']}")	
	private String KAKAO_PAY_FAIL_URL;
	
	@Autowired
	private CtBoardDao ctBoardDao;
	
	//결제준비
	public KakaoPayReady kakaoPayReady(KakaoPayOrder kakaoPayOrder)
	{
		logger.debug("[KakaoPayService] kakaopayReady 서비스쪽: 1");
		KakaoPayReady kakaoPayReady = null;
		
		if(kakaoPayOrder != null)
		{
			//http요청 후 json, xml, String 같은 응답을 받을수 있는 템플릿
			RestTemplate restTemplate = new RestTemplate();
			
			//서버로 요청할 header
			HttpHeaders headers = new HttpHeaders();
			headers.add("Authorization", "KakaoAK " + KAKAO_PAY_ADMIN_KEY);
			headers.add("Content-type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=utf-8");
			
			//서버로 요청할 body
			MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
			params.add("cid", KAKAO_PAY_CID);	
			params.add("partner_order_id", kakaoPayOrder.getPartnerOrderId());
			params.add("partner_user_id", kakaoPayOrder.getPartnerUserId());
			params.add("item_code", kakaoPayOrder.getItemCode());
			params.add("item_name", kakaoPayOrder.getItemName());
			params.add("quantity", String.valueOf(kakaoPayOrder.getQuantity()));
			params.add("total_amount", String.valueOf(kakaoPayOrder.getTotalAmount()));
			params.add("tax_free_amount", String.valueOf(kakaoPayOrder.getTaxFreeAmount()));	
			params.add("vat_amount", String.valueOf(kakaoPayOrder.getVatAmount()));
			//여기서 env로 주소를 보내줌
			params.add("approval_url", KAKAO_PAY_SUCCESS_URL);
			params.add("cancel_url", KAKAO_PAY_CANCEL_URL);
			params.add("fail_url", KAKAO_PAY_FAIL_URL);
			
			//요청하기 위해 header와 body 합치기 밑에가 합치는 작업. 결과를 객체로 받겠다. kakaopayready 객체
			//spring framework에서 제공해주는 HttpEntity클래스 header와 body를 합쳐
			HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String,String>>(params, headers);
			logger.debug("[KakaoPayService] kakaopayReady 서비스쪽: 2");
			try
			{
				logger.debug("[KakaoPayService] kakaopayReady 서비스쪽: 3");
				kakaoPayReady = restTemplate.postForObject(new URI(KAKAO_PAY_HOST + KAKAO_PAY_READY_URL), body, 
																							KakaoPayReady.class);
				logger.debug("[KakaoPayService] kakaopayReady 서비스쪽: 4");
				//정상적으로 결과를받음
				if(kakaoPayReady != null)
				{
					kakaoPayOrder.setTid(kakaoPayReady.getTid());
					logger.debug("[KakaoPayService] kakaoPayReady : " + kakaoPayReady);
				}
			}
			catch(RestClientException e)
			{
				logger.error("[KakaoPayService] kakaoPayReady RestClientException", e);
			}
			catch(URISyntaxException e)
			{
				logger.error("[KakaoPayService] kakaoPayReady URISyntaxException", e);
			}
		}
		else
		{
			logger.error("[KakaoPayService] kakaoPayReady KakaoPayOrder is null");
		}
		
		return kakaoPayReady;
	}
	
	//결제요청
	public KakaoPayApprove kakaoPayApprove(KakaoPayOrder kakaoPayOrder)
	{
		KakaoPayApprove kakaoPayApprove = null;
		
		if(kakaoPayOrder != null)
		{
			RestTemplate restTemplate = new RestTemplate();
			
			//서버 요청 header
			HttpHeaders headers = new HttpHeaders();
			headers.add("Authorization", "KakaoAK " + KAKAO_PAY_ADMIN_KEY);
			headers.add("Content-type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=utf-8");
			
			//서버로 요청할 body
			MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();	
			params.add("cid", KAKAO_PAY_CID);
			params.add("tid", kakaoPayOrder.getTid());
			params.add("partner_order_id", kakaoPayOrder.getPartnerOrderId());
			params.add("partner_user_id", kakaoPayOrder.getPartnerUserId());
			params.add("pg_token", kakaoPayOrder.getPgToken());
			
			//요청하기 위해 header와 body 합치기
			//spring framework에서 제공해주는 HttpEntity클래스 header와 body를 합쳐
			HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String,String>>(params, headers);
			
			try
			{
				//성공했을때 url 보내줌 컨트롤러로 kakaopayapprolve
				kakaoPayApprove = restTemplate.postForObject(new URI(KAKAO_PAY_HOST + KAKAO_PAY_APPROVE_URL), body, 
																				KakaoPayApprove.class);
				
				if(kakaoPayApprove != null)
				{
					logger.debug("[KakaoPayService] kakaoPayApprove : " + kakaoPayApprove);
				}
			}
			catch(RestClientException e)
			{
				logger.error("[KakaoPayService] kakaoPayApprove RestClientException", e);
			}
			catch(URISyntaxException e)
			{
				logger.error("[KakaoPayService] kakaoPayApprove URISyntaxException", e);
			}
		}
		else
		{
			logger.error("[KakaoPayService] kakaoPayApprove KakaoPayOrder is null");
		}
		
		return kakaoPayApprove;
	}
	
	public int ctPaymentInsert (CtPm ctPm, long price)
	{
		int count = 0;
		long ctBbsSeq = ctPm.getCtBbsSeq();
		logger.debug("서비스 ctBbsSeq값입니다."+ctBbsSeq);
		
		try {
			count = ctBoardDao.ctPaymentInsert(ctPm);
		} catch (Exception e) {
			logger.error("[ctBoardService] ctPaymentInsert Exception", e);
		}
		return count =0;
	}
	
	
	//펀딩 결제 정보 셀렉트 서비스
	public CtPm ctPmSelect(String paymentNum)
	{
		CtPm ctPm = new CtPm();
		
		if(paymentNum != null)
		{
			try {
				ctPm = ctBoardDao.ctPmSelect(paymentNum);
				
			} catch (Exception e) {
				logger.error("[FdBoardService] fdPmSelect Exception", e);
			}
		}
		return ctPm;
	}
	
	
	
	

}
