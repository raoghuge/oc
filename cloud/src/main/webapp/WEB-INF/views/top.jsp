
 <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="#"><span style="font-family: Impact">ourcloud.in</span></a>
          <div class="nav-collapse collapse">
          
               
			<c:if test="${not empty loggedInUsername}">		
            <p class="navbar-text pull-right">
              Logged in as : <a href="#" class="navbar-link">${loggedInUsername}</a>
            </p>
            </c:if>

            <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <c:if test="${empty loggedInUsername}">	
               <li class="dropdown">
                  <a href="#" class="dropdown-toggle" data-toggle="dropdown">Account<b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="${applicationScope.contextPath}/login">Login</a></li>
                    <li><a href="${applicationScope.contextPath}/signup">Sign Up</a></li>
                 
                    <li class="divider"></li>
                    <li class="nav-header"></li>
                  </ul>
                </li>
              
              
              </c:if>
              <c:if test="${not empty session.loggedInUsername}">	
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
              </c:if>
             
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>