package nl.amis.smeetsm.demoservice.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.DefaultSecurityFilterChain;

@Configuration
public class WebSecConfig extends WebSecurityConfigurerAdapter {
    @Bean
    DefaultSecurityFilterChain springSecurityFilterChain(HttpSecurity http) throws Exception {
        http.headers().httpStrictTransportSecurity().disable();
        return http.build();
    }
}
