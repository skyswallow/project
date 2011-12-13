var timer;

function checkForm(){
    var val = document.getElementById("username").value;
    var result = true;
    var reg = /^[\d]+$/;
    var r_val_1 = document.getElementById("book_id_1").checked;
    var r_val_2 = document.getElementById("book_id_2").checked;
    var r_val_3 = document.getElementById("book_id_3").checked;
    if(r_val_1 == false && r_val_2 == false && r_val_3 == false){
        alert("请您选择一本要申领的图书，谢谢！");
        result = false;
    }else if(val.length ==0){
        alert("请输入收到活动邀请短信的手机号码，谢谢！");
        result = false;
    }else if(val.length > 12 || !reg.test(val)){
        alert("请输入长度不超过12位的手机号码，谢谢！");
        result = false;
    }
    if(result){
        $("error1").innerHTML = "";
        return true;
    }else{
        return false;
    }
}

function show_info(num){
    var obj = document.getElementById("intro_"+num);
    for(var x=1;x<=3;x++){
        if(x!=num){
            document.getElementById("intro_"+x).style.display = "none";
            document.getElementById("intro_"+x).style.display = "none";
        }
        else{
            if(obj.style.display == "none"){
                obj.style.display = "block";
            }else{
                obj.style.display = "none";
            }
        }
    }
}

function goto_url(obj){
    var info = $("error1").innerHTML;
    if(obj != -1){
        if(obj == 2){
            window.open(site_url+"/book_activities/survey?s="+ info.split(":")[1] +"&type="+ obj+"&name="+info.split(":")[4], "","scrollbars=yes,toolbar=yes, menubar=yes, resizable=yes,location=yes, status=yes");
            window.location.reload(true);
        }else if(obj == 1 && info.split(":")[4] != ""){
            window.location.href = site_url+"/book_activities/lottery?s="+ info.split(":")[1] +"&name=" + info.split(":")[4];
        }
    }
}

function survey(){
    var info = $("error1").innerHTML;
    if(info.split(":")[0] == 2 && info.split(":")[1] !=""){
        window.open(site_url+"/book_activities/survey?s="+ info.split(":")[1] +"&type="+ info.split(":")[0] + "&name="+info.split(":")[4], "","scrollbars=yes,toolbar=yes, menubar=yes, resizable=yes,location=yes, status=yes");
        window.location.reload(true);
        clearInterval(timer);
    }else if(info.split(":")[0] == 1 && info.split(":")[4] != ""){
        window.location.href = site_url+"/book_activities/lottery?s="+ info.split(":")[1] +"&name=" + info.split(":")[4];
    }else if(info.split(":")[1] == ""){
        window.location.href = site_url+"/book_activities/lottery";
    }
}

function show_alert_1(){
    $("alert_1").style.display = "block";
    $("alert_1").addClassName("tanchu3");
    timer = setTimeout('goto_url(1)', 5000);
}

function redirect_url(status,type,name){
    window.open(site_url + "/book_activities/survey?s="+ status +"&type="+ type+"&name="+name, "","scrollbars=yes,toolbar=yes, menubar=yes, resizable=yes,location=yes, status=yes");
    window.location.reload(true);
}

function set_alert(obj,status,type,name,book_name){
    var flag = false;
    if($("intro_1").style.display == "block" || $("intro_2").style.display == "block" || $("intro_3").style.display == "block"){
        flag = true;
    }
    if(obj !=0 && obj != 2 ){
        $("lottery_info").removeClassName("tanchu");
        if(flag){
            $("lottery_info").addClassName("lottery_alert_1");
        }else{
            $("lottery_info").addClassName("lottery_alert");
        }
    }
    if(obj==-1){
        $("alert_lottery").innerHTML = "抱歉，您未中奖！";
    }else if(obj==0 || obj==2){
        $("survey").style.display = "block";
        $("is_survey").value = "0";
        Element.scrollTo($('survey'));
        alert("为提高南通市网上家长学校的服务质量，在抽奖前\n请填写一份关于您孩子学习的调查问卷，谢谢!");
    }else if(obj==7){
        $("alert_lottery").innerHTML = "抱歉，您今天的3次抽奖机会已耗尽，请明天继续抽奖。";
    }else if(obj == 8){
        $("alert_lottery").innerHTML = "抱歉，您未中奖！请再次尝试！";
    }else if(obj == 9){
        $("alert_lottery").innerHTML = "您已成功申领图书。因图书数量有限，您不能参加抽奖。";
        $("image_lottery").innerHTML = "<img src='/images/zengshu/yes.jpg'/>";
        $("lottery_span").innerHTML = "为提高南通市网上家长学校的服务质量，请填写一份关于您孩子学习的调查问卷，页面将自动跳转。谢谢！";
        $("lottery_a").style.display = "block";
        $("lottery_btn").style.display = "none";
        timer = setTimeout('redirect_url('+status+','+ type +',"'+name+'")', 5000);
        $("lottery_a").onclick = function(){
            window.open(site_url+"/book_activities/survey?s="+ status +"&type="+ type + "&name="+name, "","scrollbars=yes,toolbar=yes, menubar=yes, resizable=yes,location=yes, status=yes");
            window.location.reload(true);
            clearInterval(timer);
            return false;
        };
    }else if(obj==4){
        $("alert_lottery").innerHTML = "您已成功获赠图书。因图书数量有限，您不能再次抽奖。谢谢！";
    }else if(obj==5){
        $("alert_lottery").innerHTML = "您已成功申领图书。因图书数量有限，您不能参加抽奖。谢谢！";
        $("image_lottery").innerHTML = "<img src='/images/zengshu/yes.jpg'/>";
    }else if(obj==10){
        $("alert_lottery").innerHTML = "恭喜！您已成功获赠图书《"+book_name+"》，图书将在整个活动结束后，由您孩子所在学校送达。";
        $("image_lottery").innerHTML = "<img src='/images/zengshu/yes.jpg'/>";
    }
    if(checkSubmit()&& (obj==7 || obj ==8) ){
        new Ajax.Request("/book_activities/change_status",{
            method:"get",
            parameters:"user_info="+obj +":1:"+$("username").value
        });
    }
}
function checkLotteryForm(){
    var val = document.getElementById("username").value;
    var result = true;
    var reg = /^[\d]+$/;
    if(val.length ==0){
        alert("请输入您收到活动短信的手机号码，谢谢！");
        result = false;
    }else if(val.length > 12 || !reg.test(val)){
        alert("请输入长度不超过12位的手机号码，谢谢！");
        result = false;
    }
    if(result){
        if($("is_survey").value == 0){
            if(($("user_status").innerHTML == "0" || $("user_status").innerHTML=="2") && !checkSubmit()){
                $("survey").style.display = "block";
                Element.scrollTo($('survey'));
                alert("请在完成问卷填写后在进行抽奖，谢谢！");
                return false;
            }else{
                $("survey").style.display = "none";
                return true;
            }
        }else if($("is_survey").value == 1){
            return true;
        }else{
            return false;
        }
    }else{
        return false;
    }
}

function alert_award(obj,book){
    if(obj==0){
        alert("您未中奖，谢谢！");
    }else if(obj==1){
        alert("您已获赠《"+ book +"》，谢谢！");
    }
}

function checkSearchForm(){
    var val = document.getElementById("username").value;
    var result = true;
    var reg = /^[\d]+$/;
    if(val.length ==0){
        alert("请输入您收到活动短信的手机号码，谢谢！");
        result = false;
    }else if(val.length > 15 || !reg.test(val)){
        alert("请输入长度不超过12位的手机号码，谢谢！");
        result = false;
    }
    return result;
}

function do_sth(){
    document.getElementById('lottery_info').style.display='none';
    if(checkSubmit()){
        $("ask_form").submit();
    }else{
        window.location='/book_activities/lottery';
    }
}

function show_info_1(obj,type){
    if(obj==1){
        if($("rules").style.display=="block"){
            $("rules").style.display="none";
            $("r_a_"+obj).innerHTML="<img src='/images/zengshu/chakan_"+type+"_1.gif'/>"
        }else{
            $("rules").style.display="block";
            $("r_a_"+obj).innerHTML="<img src='/images/zengshu/guanbi_"+type+"_1.gif'/>"
        }
    }else{
        if($("circuit").style.display=="block"){
            $("circuit").style.display="none";
            $("r_a_"+obj).innerHTML="<img src='/images/zengshu/chakan_"+type+"_2.gif'/>"
        }else{
            $("circuit").style.display="block";
            $("r_a_"+obj).innerHTML="<img src='/images/zengshu/guanbi_"+type+"_2.gif'/>"
        }
    }
}