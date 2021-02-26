package nl.amis.smeetsm.demoservice.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest
class DemoRestControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testDemoRestController() throws Exception {
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/rest/demo")).andExpect(status().isOk()).andExpect(content().string("Hi there")).andReturn();
        String resultDOW = result.getResponse().getContentAsString();
        assertNotNull(resultDOW);
    }
}
