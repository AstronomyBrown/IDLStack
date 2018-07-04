/**
 * AstronTimeType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class AstronTimeType  implements java.io.Serializable {
    private java.math.BigDecimal MJDRefTime;
    private nvo_coords.AstronTimeTypeReference reference;
    private nvo_coords.AstronTimeTypeRelativeTime relativeTime;
    private java.util.Calendar ISORefTime;
    private java.util.Calendar ISOTime;
    private java.math.BigDecimal JDTime;
    private java.math.BigDecimal MJDTime;
    private java.math.BigDecimal JDRefTime;
    private nvo_coords.TimeScaleType timeScale;

    public AstronTimeType() {
    }


    /**
     * Gets the MJDRefTime value for this AstronTimeType.
     * 
     * @return MJDRefTime
     */
    public java.math.BigDecimal getMJDRefTime() {
        return MJDRefTime;
    }


    /**
     * Sets the MJDRefTime value for this AstronTimeType.
     * 
     * @param MJDRefTime
     */
    public void setMJDRefTime(java.math.BigDecimal MJDRefTime) {
        this.MJDRefTime = MJDRefTime;
    }


    /**
     * Gets the reference value for this AstronTimeType.
     * 
     * @return reference
     */
    public nvo_coords.AstronTimeTypeReference getReference() {
        return reference;
    }


    /**
     * Sets the reference value for this AstronTimeType.
     * 
     * @param reference
     */
    public void setReference(nvo_coords.AstronTimeTypeReference reference) {
        this.reference = reference;
    }


    /**
     * Gets the relativeTime value for this AstronTimeType.
     * 
     * @return relativeTime
     */
    public nvo_coords.AstronTimeTypeRelativeTime getRelativeTime() {
        return relativeTime;
    }


    /**
     * Sets the relativeTime value for this AstronTimeType.
     * 
     * @param relativeTime
     */
    public void setRelativeTime(nvo_coords.AstronTimeTypeRelativeTime relativeTime) {
        this.relativeTime = relativeTime;
    }


    /**
     * Gets the ISORefTime value for this AstronTimeType.
     * 
     * @return ISORefTime
     */
    public java.util.Calendar getISORefTime() {
        return ISORefTime;
    }


    /**
     * Sets the ISORefTime value for this AstronTimeType.
     * 
     * @param ISORefTime
     */
    public void setISORefTime(java.util.Calendar ISORefTime) {
        this.ISORefTime = ISORefTime;
    }


    /**
     * Gets the ISOTime value for this AstronTimeType.
     * 
     * @return ISOTime
     */
    public java.util.Calendar getISOTime() {
        return ISOTime;
    }


    /**
     * Sets the ISOTime value for this AstronTimeType.
     * 
     * @param ISOTime
     */
    public void setISOTime(java.util.Calendar ISOTime) {
        this.ISOTime = ISOTime;
    }


    /**
     * Gets the JDTime value for this AstronTimeType.
     * 
     * @return JDTime
     */
    public java.math.BigDecimal getJDTime() {
        return JDTime;
    }


    /**
     * Sets the JDTime value for this AstronTimeType.
     * 
     * @param JDTime
     */
    public void setJDTime(java.math.BigDecimal JDTime) {
        this.JDTime = JDTime;
    }


    /**
     * Gets the MJDTime value for this AstronTimeType.
     * 
     * @return MJDTime
     */
    public java.math.BigDecimal getMJDTime() {
        return MJDTime;
    }


    /**
     * Sets the MJDTime value for this AstronTimeType.
     * 
     * @param MJDTime
     */
    public void setMJDTime(java.math.BigDecimal MJDTime) {
        this.MJDTime = MJDTime;
    }


    /**
     * Gets the JDRefTime value for this AstronTimeType.
     * 
     * @return JDRefTime
     */
    public java.math.BigDecimal getJDRefTime() {
        return JDRefTime;
    }


    /**
     * Sets the JDRefTime value for this AstronTimeType.
     * 
     * @param JDRefTime
     */
    public void setJDRefTime(java.math.BigDecimal JDRefTime) {
        this.JDRefTime = JDRefTime;
    }


    /**
     * Gets the timeScale value for this AstronTimeType.
     * 
     * @return timeScale
     */
    public nvo_coords.TimeScaleType getTimeScale() {
        return timeScale;
    }


    /**
     * Sets the timeScale value for this AstronTimeType.
     * 
     * @param timeScale
     */
    public void setTimeScale(nvo_coords.TimeScaleType timeScale) {
        this.timeScale = timeScale;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AstronTimeType)) return false;
        AstronTimeType other = (AstronTimeType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.MJDRefTime==null && other.getMJDRefTime()==null) || 
             (this.MJDRefTime!=null &&
              this.MJDRefTime.equals(other.getMJDRefTime()))) &&
            ((this.reference==null && other.getReference()==null) || 
             (this.reference!=null &&
              this.reference.equals(other.getReference()))) &&
            ((this.relativeTime==null && other.getRelativeTime()==null) || 
             (this.relativeTime!=null &&
              this.relativeTime.equals(other.getRelativeTime()))) &&
            ((this.ISORefTime==null && other.getISORefTime()==null) || 
             (this.ISORefTime!=null &&
              this.ISORefTime.equals(other.getISORefTime()))) &&
            ((this.ISOTime==null && other.getISOTime()==null) || 
             (this.ISOTime!=null &&
              this.ISOTime.equals(other.getISOTime()))) &&
            ((this.JDTime==null && other.getJDTime()==null) || 
             (this.JDTime!=null &&
              this.JDTime.equals(other.getJDTime()))) &&
            ((this.MJDTime==null && other.getMJDTime()==null) || 
             (this.MJDTime!=null &&
              this.MJDTime.equals(other.getMJDTime()))) &&
            ((this.JDRefTime==null && other.getJDRefTime()==null) || 
             (this.JDRefTime!=null &&
              this.JDRefTime.equals(other.getJDRefTime()))) &&
            ((this.timeScale==null && other.getTimeScale()==null) || 
             (this.timeScale!=null &&
              this.timeScale.equals(other.getTimeScale())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getMJDRefTime() != null) {
            _hashCode += getMJDRefTime().hashCode();
        }
        if (getReference() != null) {
            _hashCode += getReference().hashCode();
        }
        if (getRelativeTime() != null) {
            _hashCode += getRelativeTime().hashCode();
        }
        if (getISORefTime() != null) {
            _hashCode += getISORefTime().hashCode();
        }
        if (getISOTime() != null) {
            _hashCode += getISOTime().hashCode();
        }
        if (getJDTime() != null) {
            _hashCode += getJDTime().hashCode();
        }
        if (getMJDTime() != null) {
            _hashCode += getMJDTime().hashCode();
        }
        if (getJDRefTime() != null) {
            _hashCode += getJDRefTime().hashCode();
        }
        if (getTimeScale() != null) {
            _hashCode += getTimeScale().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AstronTimeType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MJDRefTime");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "MJDRefTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "decimal"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("reference");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Reference"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeReference"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("relativeTime");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "RelativeTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeRelativeTime"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ISORefTime");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "ISORefTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("ISOTime");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "ISOTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("JDTime");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "JDTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "decimal"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("MJDTime");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "MJDTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "decimal"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("JDRefTime");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "JDRefTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "decimal"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("timeScale");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "TimeScale"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "timeScaleType"));
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
