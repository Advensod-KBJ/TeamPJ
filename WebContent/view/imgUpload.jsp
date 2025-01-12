<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Upload images with Jquery</title>
    <link rel="stylesheet" type="text/css" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" />
   
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootbox.js/4.3.0/bootbox.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
   
    <style>
        ul.cvf_uploaded_files {list-style-type: none; margin: 20px 0 0 0; padding: 0;}
        ul.cvf_uploaded_files li {background-color: #fff; border: 1px solid #ccc; border-radius: 5px; float: left; margin: 20px 20px 0 0; padding: 2px; width: 150px; height: 150px; line-height: 150px; position: relative;}
        ul.cvf_uploaded_files li img.img-thumb {width: 150px; height: 150px;}
        ul.cvf_uploaded_files .ui-selected {background: red;}
        ul.cvf_uploaded_files .highlight {border: 1px dashed #000; width: 150px; background-color: #ccc; border-radius: 5px;}
        ul.cvf_uploaded_files .delete-btn {width: 24px; border: 0; position: absolute; top: -12px; right: -14px;}
        .bg-success {padding: 7px;}
    </style>
    <script type="text/javascript">
        jQuery(document).ready(function() {        
           
            var storedFiles = [];      
            //$('.cvf_order').hide();
           
            // 번호를 붙이는 함수
            function cvf_reload_order() {
                //order가 번호가 된다
                //sortable("toArray", {attribute: 'item'}); 아이템속성읜 현재 순서를 배열로 가져온다
                var order = $('.cvf_uploaded_files').sortable('toArray', {attribute: 'item'});
                $('.cvf_hidden_field').val(order);
            }
            //번호를 새로 생성하는 함수
            //cvf_uploaded_files li에 있는 아이템의 수 만큼 번호를 생성한다
            function cvf_add_order() {
                $('.cvf_uploaded_files li').each(function(n) {
                    $(this).attr('item', n);
                    console.log(n);
                });
                // console.log(storedFiles);
            }
           
           //이미지를 드래그하면 css를 바꿔주는 부분 css만 바꿔주고 엄청난 기능은 없다
            $(function() {
                $('.cvf_uploaded_files').sortable({
                    cursor: 'move',
                    placeholder: 'highlight',
                    start: function (event, ui) {
                        ui.item.toggleClass('highlight');
                    },
                    stop: function (event, ui) {
                        ui.item.toggleClass('highlight');
                    },
                    update: function () {
                        
                        cvf_reload_order();
                        // cvf_add_order();
                    },
                    create:function(){
                        var list = this;
                        resize = function(){
                            $(list).css('height','auto');
                            $(list).height($(list).height());
                        };
                        $(list).height($(list).height());
                        $(list).find('img').load(resize).error(resize);
                    }
                });
                console.log(storedFiles);
                $('.cvf_uploaded_files').disableSelection();
            });
               //파일선택을 누르면 실행된다.    
            $('body').on('change', '.user_picked_files', function() {
               //이미지 파일을 다 불러온다
                var files = this.files;
                var i = 0;
                //불러온 파일 만큼 돌린다         
                for (i = 0; i < files.length; i++) {
                    var readImg = new FileReader();
                    var file = files[i];
                   
                    if (file.type.match('image.*')){
                        //위에서 선언해준 storedFiles 배열에 이미지를 넣는다
                        storedFiles.push(file);
                        //onload는 문서가 전부 준비된 상황 이후에 발동하도록하는데
                        //여기서 readImg = FileReader(); 이기 때문에 파일을 다 읽어오면 이미지를 어팬드시키도록한다
                        readImg.onload = (function(file) {
                            return function(e) {
                                $('.cvf_uploaded_files').append(
                                "<lmg file = '" + file.name + "'>" +                                
                                    "<img class = 'img-thumb' src = '" + e.target.result + "' />" +
                                    "<a href = '#' class = 'cvf_delete_image' title = 'Cancel'><img class = 'delete-btn' src = 'delete-btn.png' /></a>" +
                                "</li>"
                                );     
                            };
                        })(file);
                        //이미지파일을 URL로 읽어온다
                        readImg.readAsDataURL(file);
                       
                    } else {
                        alert('the file '+ file.name + ' is not an image<br/>');
                    }
                   //파일을 추가할때마다 실행해주는 테스트코드
                   //1000미리세컨드로 준상태면 파일이 올라오자마자 이미지를 움직일경우 번호가 늘어나서 업로드할때 배열이 섞여버린다
                    if(files.length === (i+1)){
                        console.log("파일이 늘어남");
                        setTimeout(function(){
                            cvf_add_order();
                        }, 100);
                    }
                }
            });
           
            // 이미지를 지우는 함수
            $('body').on('click','a.cvf_delete_image',function(e){
                e.preventDefault();
                $(this).parent().remove('');       
               
                var file = $(this).parent().attr('file');
                for(var i = 0; i < storedFiles.length; i++) {
                    if(storedFiles[i].name == file) {
                        storedFiles.splice(i, 1);
                        break;
                    }
                }
                cvf_add_order();
                
                
               
            });
                   
            // AJAX Upload
            $('body').on('click', '.cvf_upload_btn', function(e){
               
                e.preventDefault();
                cvf_reload_order();
               
                //$(".cvf_uploaded_files").html('<p><img src = "loading.gif" class = "loader" /></p>');
                var data = new FormData();
               
                var items_array = $('.cvf_hidden_field').val();
                var items = items_array.split(',');
 
                for (var i in items){
                    var item_number = items[i];
                    data.append('files' + i, storedFiles[item_number]);
                    console.log('files' + i, storedFiles[item_number]);
                }
                   
                $.ajax({
                    url: 'img.php',
                    type: 'POST',
                    contentType: false,
                    data: data,
                    processData: false,
                    cache: false,
                    success: function(response, textStatus, jqXHR) {
                        //$(".cvf_uploaded_files").html('');                                               
                        //bootbox.alert('<br /><p class = "bg-success">File(s) uploaded successfully.</p>');
                        alert(jqXHR.responseText);
                    }
                });
               
            });        
 
        });
    </script>
</head>
<body>
    <div class = "container-fluid">
        <h3>Sort Files before upload</h3>
        <br />
        <div class = "col-md-6">
           
            <div class = "form-group">
                <label>Select Images</label>
                <input type = "file" name = "upload" multiple = "multiple" class = "form-control user_picked_files" />                 
            </div>                     
           
            <div class = "form-group cvf_order">                           
                <label>Order</label>                               
                <input type = "text" class = "form-control cvf_hidden_field" value = "" disabled = "disabled" />   
            </div>                     
           
            <input type = "submit" class = "cvf_upload_btn btn btn-primary" value = "Upload" />
           
            <ul class = "cvf_uploaded_files"></ul>
           
        </div>
    </div>
</body>
</html>
