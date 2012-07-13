class jenkins ($ensure = "installed", $jenkins_home = "/ebs/jenkins") {

    include tomcat

    $tomcat_package = "$tomcat::install::tomcat_package_name"
    $tomcat_user = "$tomcat::install::tomcat_user"

    include wget

    file { "$jenkins_home":
        ensure => "directory",
        owner => "$tomcat_user",
        group => "$tomcat_user",
        mode => "0755"
    }       

    file { "/usr/share/$tomcat_user/.jenkins":
      ensure => link,
      target => "$jenkins_home",
      require => File["$jenkins_home"]
    }

    wget::fetch { "jenkins-latest-war-download":
        source => "http://mirrors.jenkins-ci.org/war/latest/jenkins.war",
        destination => "/var/lib/$tomcat_package/webapps/jenkins.war",
        require => [File["/usr/share/$tomcat_package/.jenkins"], Package["$tomcat_package"]],
    }

}
