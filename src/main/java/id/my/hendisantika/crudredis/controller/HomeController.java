package id.my.hendisantika.crudredis.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Created by IntelliJ IDEA.
 * Project : spring-boot-crud-redis
 * User: hendisantika
 * Link: s.id/hendisantika
 * Email: hendisantika@yahoo.co.id
 * Telegram : @hendisantika34
 * Date: 19/10/25
 * Time: 10.45
 * To change this template use File | Settings | File Templates.
 */

/**
 * Home controller
 */
@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "redirect:/products";
    }
}
