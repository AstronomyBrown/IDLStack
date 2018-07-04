/**
 * Organisation.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class Organisation  extends net.ivoa.www.xml.VOResource.v0_10.Resource  implements java.io.Serializable {
    private net.ivoa.www.xml.VOResource.v0_10.ResourceName[] facility;
    private net.ivoa.www.xml.VOResource.v0_10.ResourceName[] instrument;

    public Organisation() {
    }


    /**
     * Gets the facility value for this Organisation.
     * 
     * @return facility
     */
    public net.ivoa.www.xml.VOResource.v0_10.ResourceName[] getFacility() {
        return facility;
    }


    /**
     * Sets the facility value for this Organisation.
     * 
     * @param facility
     */
    public void setFacility(net.ivoa.www.xml.VOResource.v0_10.ResourceName[] facility) {
        this.facility = facility;
    }

    public net.ivoa.www.xml.VOResource.v0_10.ResourceName getFacility(int i) {
        return this.facility[i];
    }

    public void setFacility(int i, net.ivoa.www.xml.VOResource.v0_10.ResourceName value) {
        this.facility[i] = value;
    }


    /**
     * Gets the instrument value for this Organisation.
     * 
     * @return instrument
     */
    public net.ivoa.www.xml.VOResource.v0_10.ResourceName[] getInstrument() {
        return instrument;
    }


    /**
     * Sets the instrument value for this Organisation.
     * 
     * @param instrument
     */
    public void setInstrument(net.ivoa.www.xml.VOResource.v0_10.ResourceName[] instrument) {
        this.instrument = instrument;
    }

    public net.ivoa.www.xml.VOResource.v0_10.ResourceName getInstrument(int i) {
        return this.instrument[i];
    }

    public void setInstrument(int i, net.ivoa.www.xml.VOResource.v0_10.ResourceName value) {
        this.instrument[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Organisation)) return false;
        Organisation other = (Organisation) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.facility==null && other.getFacility()==null) || 
             (this.facility!=null &&
              java.util.Arrays.equals(this.facility, other.getFacility()))) &&
            ((this.instrument==null && other.getInstrument()==null) || 
             (this.instrument!=null &&
              java.util.Arrays.equals(this.instrument, other.getInstrument())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getFacility() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getFacility());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getFacility(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getInstrument() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getInstrument());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getInstrument(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Organisation.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Organisation"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("facility");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "facility"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ResourceName"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("instrument");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "instrument"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ResourceName"));
        elemField.setMinOccurs(0);
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
