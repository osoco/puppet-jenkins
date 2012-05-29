class jenkins ($ensure = "installed", $jenkins_home = "/ebs/jenkins") {

    include tomcat

    $tomcat_package = "$tomcat::$tomcat_package"

    include wget

    file { "$jenkins_home":
        ensure => "directory",
        owner => "$tomcat_package",
        group => "$tomcat_package",
        mode => "0755"
    }       

    file { '/usr/share/$tomcat_package/.jenkins':
      ensure => link,
      target => "$jenkins_home",
      require => File["$jenkins_home"]
    }

    wget::fetch { "jenkins-latest-war-download":
        source => "http://mirrors.jenkins-ci.org/war/latest/jenkins.war",
        destination => "/var/lib/$tomcat_package/webapps/jenkins.war",
        require => [File['/usr/share/$tomcat_package/.jenkins'], Package["$tomcat_package"]],
        notify => Service["$tomcat_package"]
    }

}
