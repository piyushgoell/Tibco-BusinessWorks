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
import io.jsonwebtoken.LocatorAdapter;

public class Security extends LocatorAdapter<Key> {

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
			Jws<Claims> jws = jwtParser.parseSignedClaims(JwtToken);
			return getJwtClaims(jws.getPayload());
			
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
			//jwtParser = Jwts.parser().setAllowedClockSkewSeconds(clockSkewSeconds).setSigningKey(rsaKey).setSigningKeyResolver(new Security()).build();
			jwtParser = Jwts.parser().clockSkewSeconds(clockSkewSeconds).keyLocator(new Security()).build();
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
    public Key locate(JwsHeader header) { // both JwsHeader and JweHeader extend ProtectedHeader

        //inspect the header, lookup and return the verification key
        String keyId = header.getKeyId(); //or any other parameter that you need to inspect

        Key key = signingKeys.getOrDefault(keyId, null); 

        return key;
    }
	

	
	
}
