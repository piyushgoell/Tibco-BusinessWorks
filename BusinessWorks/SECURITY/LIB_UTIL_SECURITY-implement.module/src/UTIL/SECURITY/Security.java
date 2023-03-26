package UTIL.SECURITY;

import java.math.BigInteger;
import java.security.Key;
import java.security.KeyFactory;
import java.security.spec.RSAPublicKeySpec;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwsHeader;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SigningKeyResolver;;

public class Security implements SigningKeyResolver {

	private static String KeyFactoryAlgorithm = "RSA";
	private static JwtParser jwtParser;
	private static ConcurrentHashMap<String, Key> signingKeys = new ConcurrentHashMap<>();
	
	public Security(){
		super();
	}
	
	 public boolean verifyToken(String token) throws Exception  {
	        try {
	        	jwtParser.parse(token);
	            return true;
	        } catch (Exception ex) {
	            throw ex;
	        }
	 }
	 
	public static String[] ParseJwt(String JwtToken, Boolean AllowExpiredJwt) throws Exception {
		try{
			Jws<Claims> jws = jwtParser.parseClaimsJws(JwtToken);
			return getJwtClaims(jws.getBody());
			
		}catch (Exception ex){
			if(AllowExpiredJwt==true && ex instanceof ExpiredJwtException){
				return getJwtClaims(((ExpiredJwtException) ex).getClaims());
			}
			else {
				throw ex;
			}
		}
		
	}
	
	public static String [] GetRSASigningKeys() throws Exception{
		
		String [] keys = new String[signingKeys.size()];
		int index = 0;
		for(Entry<String,Key> key : signingKeys.entrySet()){
			keys[index++] = key.getKey();
		}
		return keys;
		
	}
	
	public static void RemoveRSASigningKeys(String kid)throws Exception {
			
			signingKeys.remove(kid);
			
		}
	
	public static void InsertRSASigningKeys(String kid, String modulus, String exponent, long clockSkewSeconds) throws Exception{
		
		try {
			Key rsaKey = KeyFactory.getInstance(KeyFactoryAlgorithm).generatePrivate(new RSAPublicKeySpec(new BigInteger(modulus),new BigInteger(exponent)));
			
			signingKeys.put(kid, rsaKey);
			jwtParser = Jwts.parserBuilder().setAllowedClockSkewSeconds(clockSkewSeconds).setSigningKey(rsaKey).setSigningKeyResolver(new Security()).build();
			
		} catch (Exception ex) {
			throw ex;
		} 
		
	}
	
	private static String[] getJwtClaims(Claims claims){
		int index=0;
		String jwtClaims[] = new String[claims.size()];
		for(Entry<String,Object> claim : claims.entrySet()){
			jwtClaims[index++] = claim.getKey() + "=" + claim.getValue();
		}
		return jwtClaims;
	}

	@Override
	public Key resolveSigningKey(@SuppressWarnings("rawtypes") JwsHeader header, Claims claims) {
		String kid = header.getKeyId();
		if(kid != null)
				return signingKeys.getOrDefault(kid, null);
		else
			return null;
	}

	@Override
	public Key resolveSigningKey(@SuppressWarnings("rawtypes") JwsHeader header, String plaintext) {
		String kid = header.getKeyId();
		if(kid != null)
				return signingKeys.getOrDefault(kid, null);
		else
			return null;
	}

	
	
	
}
