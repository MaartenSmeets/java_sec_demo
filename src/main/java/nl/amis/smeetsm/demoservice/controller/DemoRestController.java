package nl.amis.smeetsm.demoservice.controller;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * DemoRestController.
 */
@RestController
public class DemoRestController {
    /**
     * @return Hi there.
     */

    @GetMapping("/rest/demo")
    public String demoReply() {
        return "Hi there";
    }
}
