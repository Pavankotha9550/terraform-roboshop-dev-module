variable "project"{
    default="roboshop"
}

variable "environment"{
    default="dev"
}

variable "server"{
  default= "catalogue"
}

variable "zone_name"{
    default= "daws84.cyou"
}

variable "component"{
    type = String
}

variable "priority"{
    type = number
}
